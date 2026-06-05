import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/seasonal_settings_repository_provider.dart';
import '../domain/seasonal_settings.dart';
import 'seasonal_state.dart';

part 'seasonal_controller.g.dart';

/// Контроллер экрана 35 «Сезонные интервалы». Не family (настройки текущего
/// пользователя одни).
///
/// Контракт для UI:
/// - провайдер `seasonalControllerProvider` → `AsyncValue<SeasonalState>`.
/// - `build` грузит `GET /api/v1/me` → [SeasonalState] (`saving=false`). Ошибка
///   загрузки → `AsyncError(ApiError)` (UI: ErrorState + retry через
///   `ref.invalidate`).
/// - [toggle] оптимистично меняет тумблер и PATCH'ит `seasonalEnabled`. По
///   успеху фиксирует серверное состояние; по ошибке откатывает `enabled` и
///   кладёт `saveError` (UI: снэкбар). No-op, если уже идёт сохранение.
@riverpod
class SeasonalController extends _$SeasonalController {
  @override
  Future<SeasonalState> build() async {
    final result =
        await ref.watch(seasonalSettingsRepositoryProvider).getSettings();
    return switch (result) {
      Success(:final value) => SeasonalState(settings: value),
      Failure(:final error) => throw error,
    };
  }

  /// Переключает авто-подстройку по сезонам на [enabled].
  ///
  /// Оптимистично: тумблер встаёт в новое положение сразу, затем уходит PATCH.
  /// По успеху берём серверное состояние (backend — источник правды). По ошибке
  /// откатываем `enabled` на прежнее и кладём `saveError`. Возвращает [ApiError]
  /// при неудаче, `null` при успехе/no-op.
  Future<ApiError?> toggle(bool enabled) async {
    final current = state.value;
    if (current == null || current.saving) return null;
    if (current.settings.enabled == enabled) return null;

    final previous = current.settings;

    // Оптимистичное обновление вида + флаг сохранения.
    state = AsyncData(
      current.copyWith(
        settings: previous.copyWith(enabled: enabled),
        saving: true,
        saveError: null,
      ),
    );

    final result =
        await ref.read(seasonalSettingsRepositoryProvider).setEnabled(enabled);
    if (!ref.mounted) return null;

    return switch (result) {
      Success(:final value) => _onSaved(value),
      Failure(:final error) => _onSaveError(error, previous),
    };
  }

  /// Успех PATCH: серверное состояние становится подтверждённым. Возвращает
  /// `null`.
  ApiError? _onSaved(SeasonalSettings value) {
    final latest = state.value;
    if (latest == null) return null;
    state = AsyncData(
      latest.copyWith(settings: value, saving: false, saveError: null),
    );
    return null;
  }

  /// Ошибка PATCH: откат тумблера на [previous], кладём `saveError`.
  ApiError? _onSaveError(ApiError error, SeasonalSettings previous) {
    final latest = state.value;
    if (latest == null) return error;
    state = AsyncData(
      latest.copyWith(settings: previous, saving: false, saveError: error),
    );
    return error;
  }
}
