import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/user_settings_repository_provider.dart';
import '../domain/quiet_time.dart';
import '../domain/user_settings.dart';
import 'quiet_hours_state.dart';

part 'quiet_hours_controller.g.dart';

/// Контроллер экрана «Тихие часы и время» (23). Не family (настройки текущего
/// пользователя одни).
///
/// Контракт для ui-builder:
/// - провайдер `quietHoursControllerProvider` → `AsyncValue<QuietHoursState>`.
/// - `build` грузит `GET /api/v1/me` и кладёт результат и в `loaded`, и в
///   `draft` (исходно драфт = загруженному, грязи нет). Ошибка загрузки →
///   `AsyncError(ApiError)`.
/// - чтение: `state.draft` (что рисовать), `state.isDirty` /
///   `state.isQuietHoursDirty` / `state.isTimezoneDirty` (несохранённое),
///   `state.saving` (идёт PATCH), `state.saveError` (ошибка последнего save).
///
/// Стратегия — «draft + save»:
/// - [setQuietStart] / [setQuietEnd] / [setTimezone] правят ТОЛЬКО `draft`, в
///   сеть НЕ ходят (пикер 36 / выбор 37 — оптимистично);
/// - [save] PATCH'ит только изменённое подмножество. По успеху `loaded = ответ
///   сервера` (серверная нормализация), грязь исчезает. По ошибке — `saveError`,
///   `draft` сохранён (пользователь повторяет).
@riverpod
class QuietHoursController extends _$QuietHoursController {
  @override
  Future<QuietHoursState> build() async {
    final result = await ref.watch(userSettingsRepositoryProvider).getSettings();
    return switch (result) {
      Success(:final value) => QuietHoursState(loaded: value, draft: value),
      Failure(:final error) => throw error,
    };
  }

  /// Устанавливает начало тихих часов в драфте (пикер 36). В сеть не ходит.
  void setQuietStart(QuietTime start) {
    _editDraft((s) => s.copyWith(quietHoursStart: start));
  }

  /// Устанавливает конец тихих часов в драфте (пикер 36). В сеть не ходит.
  void setQuietEnd(QuietTime end) {
    _editDraft((s) => s.copyWith(quietHoursEnd: end));
  }

  /// Устанавливает таймзону в драфте по IANA-идентификатору (выбор 37). В сеть
  /// не ходит — запись произойдёт в [save].
  void setTimezone(String iana) {
    _editDraft((s) => s.copyWith(timezone: iana));
  }

  /// Откатывает драфт к последнему подтверждённому backend состоянию (UI
  /// «Отмена»). Сбрасывает `saveError`.
  void discardChanges() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(draft: current.loaded, saveError: null),
    );
  }

  /// Сохраняет изменённое подмножество (`PATCH /api/v1/me`).
  ///
  /// Возвращает `null` при успехе (или если сохранять нечего) и [ApiError] при
  /// неудаче (UI: `null` → закрыть/остаться; иначе показать ошибку, напр.
  /// backend отверг совпадение `start == end`). No-op (возвращает `null`), если
  /// нет изменений или уже идёт сохранение.
  ///
  /// PATCH-семантика: шлём только грязные поля. Тихие часы и таймзона могут
  /// меняться независимо; если изменено и то, и другое — отправляем обоими
  /// полями в одном PATCH (одной ручкой `/me`).
  Future<ApiError?> save() async {
    final current = state.value;
    if (current == null || current.saving) return null;
    if (!current.isDirty) return null;

    state = AsyncData(current.copyWith(saving: true, saveError: null));

    final repo = ref.read(userSettingsRepositoryProvider);
    final draft = current.draft;

    // Один PATCH со всеми изменёнными полями. Если изменена только таймзона —
    // уходит только она; только тихие часы — только они; оба — оба (двумя
    // PATCH'ами: репозиторий разделяет update'ы по смыслу).
    Result<UserSettings> result;
    if (current.isTimezoneDirty && !current.isQuietHoursDirty) {
      result = await repo.updateTimezone(draft.timezone);
    } else {
      result = await repo.updateQuietHours(
        start: current.isQuietHoursDirty ? draft.quietHoursStart : null,
        end: current.isQuietHoursDirty ? draft.quietHoursEnd : null,
      );
      // Таймзона изменена вместе с тихими часами: второй PATCH. Перед ним
      // инкрементально фиксируем уже сохранённые часы в `loaded` — иначе при
      // фейле второго PATCH'а стейт транзиентно соврёт (часы на бэке записаны,
      // а `isQuietHoursDirty` остался бы `true`).
      if (result is Success<UserSettings> && current.isTimezoneDirty) {
        if (!ref.mounted) return null;
        _commitSaved(result.value);
        result = await repo.updateTimezone(draft.timezone);
      }
    }
    if (!ref.mounted) return null;

    return switch (result) {
      Success(:final value) => _onSaved(value),
      Failure(:final error) => _onSaveError(error),
    };
  }

  // --- helpers ---

  /// Применяет [edit] к драфту, сбрасывает `saveError`. No-op без данных.
  void _editDraft(UserSettings Function(UserSettings) edit) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(draft: edit(current.draft), saveError: null),
    );
  }

  /// Инкрементальная фиксация частичного успеха: серверный ответ первого PATCH
  /// (часы записаны, таймзона ещё старая) становится новым `loaded`. `draft`
  /// ребейзится на него, но СОХРАНЯЕТ ещё не записанную грязную таймзону —
  /// чтобы `isQuietHoursDirty` стало `false`, а `isTimezoneDirty` осталось
  /// `true`. Так при фейле второго PATCH стейт точен. `saving`/`saveError` не
  /// трогаем — операция ещё в полёте.
  void _commitSaved(UserSettings saved) {
    final latest = state.value;
    if (latest == null) return;
    state = AsyncData(
      latest.copyWith(
        loaded: saved,
        draft: saved.copyWith(timezone: latest.draft.timezone),
      ),
    );
  }

  /// Успех PATCH: серверное состояние становится и `loaded`, и `draft` (грязь
  /// исчезает, серверная нормализация учтена). Возвращает `null`.
  ApiError? _onSaved(UserSettings saved) {
    final latest = state.value;
    if (latest == null) return null;
    state = AsyncData(
      latest.copyWith(
        loaded: saved,
        draft: saved,
        saving: false,
        saveError: null,
      ),
    );
    return null;
  }

  /// Ошибка PATCH: драфт сохранён (пользователь повторит), кладём `saveError`.
  ApiError? _onSaveError(ApiError error) {
    final latest = state.value;
    if (latest == null) return error;
    state = AsyncData(latest.copyWith(saving: false, saveError: error));
    return error;
  }
}
