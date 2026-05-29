import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/care/care_task_type.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/edit_schedule_repository_provider.dart';
import '../domain/care_schedule_unit.dart';
import '../domain/plant_care_schedule.dart';
import 'edit_schedule_state.dart';

part 'edit_schedule_controller.g.dart';

/// Контроллер экрана «Редактирование расписания ухода» (22). Family по
/// [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editScheduleControllerProvider(plantId)` →
///   `AsyncValue<EditScheduleState>`.
/// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
///   загрузки → `AsyncError(ApiError)`.
/// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
///   `state.saveError` (ошибка последнего `save`).
///
/// Стратегия редактирования — «draft + save dirty on Готово»:
/// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
///   `draft`, в сеть не ходят;
/// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
///   По полному успеху `loaded = draft`, грязь исчезает.
@riverpod
class EditScheduleController extends _$EditScheduleController {
  @override
  Future<EditScheduleState> build(int plantId) async {
    final result =
        await ref.watch(editScheduleRepositoryProvider).getSchedules(plantId);
    return switch (result) {
      Success(:final value) => EditScheduleState(
          loaded: value,
          draft: value,
        ),
      Failure(:final error) => throw error,
    };
  }

  /// Переключает активность расписания [type] в драфте.
  void toggle(CareTaskType type) {
    _editDraft(type, (s) => s.copyWith(enabled: !s.enabled));
  }

  /// Устанавливает интервал [every] для [type]. Клампится до `>= 1` (степпер
  /// UI не должен опускать ниже 1; защита здесь — на случай прямого вызова).
  void setEvery(CareTaskType type, int every) {
    final clamped = every < 1 ? 1 : every;
    _editDraft(type, (s) => s.copyWith(every: clamped));
  }

  /// Устанавливает объём воды [amountMl] (для полива). `null` — снять значение.
  /// Отрицательные значения клампятся к 0; передавать `null` для «не задано».
  void setAmountMl(CareTaskType type, int? amountMl) {
    final normalized = amountMl == null ? null : (amountMl < 0 ? 0 : amountMl);
    _editDraft(type, (s) => s.copyWith(amountMl: normalized));
  }

  /// Сбрасывает интервалы драфта к рекомендованным для вида ([recommendedDays]:
  /// `CareTaskType` → дней). Для каждого присутствующего в драфте типа, у
  /// которого есть рекомендация, выставляет `every = recommendedDays[type]`
  /// (клампится `>= 1`), `unit = DAY` и `rawUnit = 'DAY'`.
  ///
  /// `amountMl` НЕ трогаем: рекомендации вида объёма воды не несут (только
  /// интервалы *Days), а сброс объёма пользователя при «вернуть интервалы»
  /// был бы неожиданным. `enabled` тоже не меняем — сброс касается только
  /// интервала. Типы без рекомендации остаются как есть.
  void reset(Map<CareTaskType, int> recommendedDays) {
    final current = state.value;
    if (current == null) return;
    final newDraft = current.draft.map((s) {
      final days = recommendedDays[s.type];
      if (days == null) return s;
      return s.copyWith(
        every: days < 1 ? 1 : days,
        unit: CareScheduleUnit.day,
        rawUnit: 'DAY',
      );
    }).toList(growable: false);
    state = AsyncData(current.copyWith(draft: newDraft, saveError: null));
  }

  /// Сохраняет только грязные типы (PUT по каждому последовательно).
  ///
  /// Возвращает `null` при полном успехе или `ApiError` первой неудачи (UI:
  /// `null` → закрыть экран; иначе показать ошибку). No-op (возвращает `null`),
  /// если нечего сохранять или уже идёт сохранение.
  ///
  /// Partial-failure: успешно сохранённые расписания фиксируются в `loaded`
  /// (ответом сервера, с пересчитанным `nextDueAt`) — НЕ откатываются. При
  /// первой ошибке останавливаемся, кладём `saveError`, грязными остаются
  /// несохранённые типы — пользователь может повторить `save`.
  Future<ApiError?> save() async {
    final current = state.value;
    if (current == null || current.saving) return null;

    final dirty = current.dirtyTypes;
    if (dirty.isEmpty) return null;

    state = AsyncData(current.copyWith(saving: true, saveError: null));

    final repo = ref.read(editScheduleRepositoryProvider);
    // Работаем от изменяемых копий, чтобы пофайлово фиксировать успехи в loaded.
    var loaded = [...current.loaded];
    final draft = current.draft;
    ApiError? firstError;

    for (final type in dirty) {
      final scheduleToSave = _scheduleOf(draft, type);
      if (scheduleToSave == null) continue;

      final result = await repo.updateSchedule(plantId, scheduleToSave);
      if (!ref.mounted) return firstError;

      switch (result) {
        case Success(:final value):
          // Фиксируем подтверждённое сервером расписание в loaded (с
          // пересчитанным nextDueAt). Грязь по этому типу исчезает.
          loaded = _replaceByType(loaded, value);
        case Failure(:final error):
          firstError = error;
          // Останавливаемся на первой ошибке: успешные уже зафиксированы,
          // непрошедшие остаются грязными (loaded по ним не тронут).
          break;
      }
    }

    final latest = state.value;
    if (latest == null) return firstError;
    state = AsyncData(
      latest.copyWith(loaded: loaded, saving: false, saveError: firstError),
    );
    return firstError;
  }

  // --- helpers ---

  /// Применяет [edit] к расписанию [type] в драфте, сбрасывает `saveError`.
  /// No-op, если нет данных или тип не найден.
  void _editDraft(
    CareTaskType type,
    PlantCareSchedule Function(PlantCareSchedule) edit,
  ) {
    final current = state.value;
    if (current == null) return;
    var changed = false;
    final newDraft = current.draft.map((s) {
      if (s.type != type) return s;
      changed = true;
      return edit(s);
    }).toList(growable: false);
    if (!changed) return;
    state = AsyncData(current.copyWith(draft: newDraft, saveError: null));
  }

  static PlantCareSchedule? _scheduleOf(
    List<PlantCareSchedule> list,
    CareTaskType type,
  ) {
    for (final s in list) {
      if (s.type == type) return s;
    }
    return null;
  }

  static List<PlantCareSchedule> _replaceByType(
    List<PlantCareSchedule> list,
    PlantCareSchedule replacement,
  ) =>
      list
          .map((s) => s.type == replacement.type ? replacement : s)
          .toList(growable: false);
}
