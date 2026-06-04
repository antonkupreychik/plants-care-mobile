import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/care/care_task_type.dart';
import '../../../core/error/result.dart';
// Кросс-фичевая инвалидация после успешного POST: созданное растение должно
// появиться в саду. Импорт presentation-провайдера home — то же осознанное
// исключение из «фича не импортит presentation другой фичи», что и в
// log_care_event_controller (зависим от объявления провайдера, не от виджетов).
import '../../home/presentation/home_providers.dart';
// Кросс-фичевая зависимость на data/domain edit_schedule: выделять отдельный
// репозиторий/use-case нецелесообразно — операция одна (PUT schedule) и уже
// реализована в edit_schedule. Аналогичный precedent — home_providers.dart выше.
// Зависимость только на интерфейс-провайдер и доменные модели, не на виджеты.
import '../../edit_schedule/data/edit_schedule_repository_provider.dart';
import '../../edit_schedule/domain/care_schedule_unit.dart';
import '../../edit_schedule/domain/plant_care_schedule.dart';
import '../data/add_plant_repository_provider.dart';
import '../domain/new_plant_draft.dart';
import '../domain/species_summary.dart';
import '../domain/window_side.dart';
import 'add_plant_wizard_state.dart';

part 'add_plant_wizard_controller.g.dart';

/// Контроллер мастера добавления растения (экран 04) — держит черновик и ведёт
/// сабмит. Не family: один мастер за раз (autoDispose сбрасывает черновик при
/// закрытии). Виджет читает `ref.watch(addPlantWizardControllerProvider)` и
/// зовёт методы; бизнес-логики/валидации в виджете нет (MADR-002).
///
/// Use case для создания нет (репозиторий тонкий, доменная логика — только
/// валидация имени в [NewPlantDraft]), поэтому [submit] зовёт репозиторий через
/// провайдер напрямую — допустимо, когда отдельного use case не существует.
@riverpod
class AddPlantWizardController extends _$AddPlantWizardController {
  @override
  AddPlantWizardState build() => const AddPlantWizardState();

  /// Выбрать вид (шаг 1). Если имя ещё не введено — префиллим именем вида
  /// (UX: пользователь обычно оставляет его). Сбрасывает статус в idle.
  void selectSpecies(SpeciesSummary species) {
    final draft = state.draft;
    final shouldPrefillName = draft.name.trim().isEmpty;
    state = state.copyWith(
      draft: draft.copyWith(
        species: species,
        name: shouldPrefillName ? species.name : draft.name,
        // Сброс оверрайдов при смене вида: рекомендации у нового вида другие.
        intervalOverrides: const {},
      ),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Задать имя растения (шаг 2). Валидность проверяет [AddPlantWizardState.canSubmit].
  void setName(String name) {
    state = state.copyWith(
      draft: state.draft.copyWith(name: name),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Выбрать локацию (шаг 2). null → дефолтная локация на стороне backend.
  void setLocation(int? locationId) {
    state = state.copyWith(
      draft: state.draft.copyWith(locationId: locationId),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Обновить заметки (шаг 4). Пусто → без заметок.
  void setNotes(String? notes) {
    final trimmed = notes?.trim();
    state = state.copyWith(
      draft: state.draft.copyWith(
        notes: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      ),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Выбрать сторону окна (шаг 04c). Повторный тап по выбранной снимает выбор
  /// (toggle). UI-only: в `POST /plants` не уходит, хранится в черновике.
  void setWindowSide(WindowSide? side) {
    final current = state.draft.windowSide;
    state = state.copyWith(
      draft: state.draft.copyWith(
        windowSide: current == side ? null : side,
      ),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Изменить интервал ухода [type] на [every] дней (шаг 3).
  ///
  /// Если [every] совпадает с рекомендацией вида — запись из оверрайдов
  /// удаляется (нет смысла делать лишний PUT). Клампится до >= 1.
  void setIntervalOverride(CareTaskType type, int every) {
    final clamped = every < 1 ? 1 : every;
    final carePlan = state.draft.species?.carePlan ?? const [];
    int? defaultEvery;
    for (final item in carePlan) {
      if (item.type == type) {
        defaultEvery = item.everyDays;
        break;
      }
    }

    final overrides = Map<CareTaskType, int>.of(state.draft.intervalOverrides);
    if (defaultEvery != null && clamped == defaultEvery) {
      overrides.remove(type);
    } else {
      overrides[type] = clamped;
    }

    state = state.copyWith(
      draft: state.draft.copyWith(intervalOverrides: overrides),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Создать растение (`POST /plants`), затем применить изменённые интервалы
  /// (`PUT /plants/{id}/schedules/{type}` — только грязные типы).
  ///
  /// Single-call gate через [canSubmit] (валидное имя + нет активной отправки).
  /// Возвращает id созданной записи при успехе, иначе null.
  ///
  /// Фазы:
  /// 1. `submitting` → POST → при ошибке → `failure`, выходим.
  /// 2. `savingSchedules` → PUT по каждому оверрайду последовательно →
  ///    при первой ошибке → `scheduleFailure(plantId, error)`.
  /// 3. Полный успех → `success(plantId)`.
  ///
  /// `scheduleFailure` означает: растение создано, но интервалы не применились.
  /// UI навигирует на editSchedule в обоих случаях.
  Future<int?> submit() async {
    if (!state.canSubmit) return null;

    final draft = state.draft;
    state = state.copyWith(status: const AddPlantSubmitStatus.submitting());

    final createResult = await ref.read(addPlantRepositoryProvider).createPlant(
          name: draft.trimmedName,
          locationId: draft.locationId,
          notes: draft.notes,
          speciesId: draft.species?.id,
        );

    if (!ref.mounted) return null;

    final int plantId;
    switch (createResult) {
      case Success(:final value):
        ref.invalidate(homePlantsProvider);
        plantId = value;
      case Failure(:final error):
        state = state.copyWith(status: AddPlantSubmitStatus.failure(error));
        return null;
    }

    final overrides = draft.intervalOverrides;
    if (overrides.isEmpty) {
      state = state.copyWith(status: AddPlantSubmitStatus.success(plantId));
      return plantId;
    }

    state = state.copyWith(
      status: const AddPlantSubmitStatus.savingSchedules(),
    );

    final scheduleRepo = ref.read(editScheduleRepositoryProvider);
    for (final entry in overrides.entries) {
      final schedule = PlantCareSchedule(
        type: entry.key,
        rawType: entry.key.apiString,
        every: entry.value,
        unit: CareScheduleUnit.day,
        rawUnit: 'DAY',
        enabled: true,
      );
      final putResult = await scheduleRepo.updateSchedule(plantId, schedule);

      if (!ref.mounted) return null;

      if (putResult case Failure(:final error)) {
        state = state.copyWith(
          status: AddPlantSubmitStatus.scheduleFailure(
            plantId: plantId,
            error: error,
          ),
        );
        return null;
      }
    }

    state = state.copyWith(status: AddPlantSubmitStatus.success(plantId));
    return plantId;
  }
}
