// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана 35 «Сезонные настройки» (/me/seasonal). Не family
/// (настройки текущего пользователя одни).
///
/// Контракт для UI:
/// - провайдер `seasonalControllerProvider` → `AsyncValue<SeasonalState>`.
/// - `build` грузит `GET /api/v1/me/seasonal` → [SeasonalState]. Ошибка
///   загрузки → `AsyncError(ApiError)` (UI: ErrorState + retry через
///   `ref.invalidate`).
/// - [toggle] оптимистично меняет тумблер и PATCH'ит `seasonalEnabled`. По
///   успеху фиксирует серверное состояние; по ошибке откатывает `enabled` и
///   кладёт `saveError` (UI: снэкбар). No-op, если уже идёт сохранение.
/// - [resetSeason] сбрасывает intervalDays сезона через DELETE.

@ProviderFor(SeasonalController)
final seasonalControllerProvider = SeasonalControllerProvider._();

/// Контроллер экрана 35 «Сезонные настройки» (/me/seasonal). Не family
/// (настройки текущего пользователя одни).
///
/// Контракт для UI:
/// - провайдер `seasonalControllerProvider` → `AsyncValue<SeasonalState>`.
/// - `build` грузит `GET /api/v1/me/seasonal` → [SeasonalState]. Ошибка
///   загрузки → `AsyncError(ApiError)` (UI: ErrorState + retry через
///   `ref.invalidate`).
/// - [toggle] оптимистично меняет тумблер и PATCH'ит `seasonalEnabled`. По
///   успеху фиксирует серверное состояние; по ошибке откатывает `enabled` и
///   кладёт `saveError` (UI: снэкбар). No-op, если уже идёт сохранение.
/// - [resetSeason] сбрасывает intervalDays сезона через DELETE.
final class SeasonalControllerProvider
    extends $AsyncNotifierProvider<SeasonalController, SeasonalState> {
  /// Контроллер экрана 35 «Сезонные настройки» (/me/seasonal). Не family
  /// (настройки текущего пользователя одни).
  ///
  /// Контракт для UI:
  /// - провайдер `seasonalControllerProvider` → `AsyncValue<SeasonalState>`.
  /// - `build` грузит `GET /api/v1/me/seasonal` → [SeasonalState]. Ошибка
  ///   загрузки → `AsyncError(ApiError)` (UI: ErrorState + retry через
  ///   `ref.invalidate`).
  /// - [toggle] оптимистично меняет тумблер и PATCH'ит `seasonalEnabled`. По
  ///   успеху фиксирует серверное состояние; по ошибке откатывает `enabled` и
  ///   кладёт `saveError` (UI: снэкбар). No-op, если уже идёт сохранение.
  /// - [resetSeason] сбрасывает intervalDays сезона через DELETE.
  SeasonalControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalControllerHash();

  @$internal
  @override
  SeasonalController create() => SeasonalController();
}

String _$seasonalControllerHash() =>
    r'b8ae76995038386ed88e537f7f93f16d8c9d9b4d';

/// Контроллер экрана 35 «Сезонные настройки» (/me/seasonal). Не family
/// (настройки текущего пользователя одни).
///
/// Контракт для UI:
/// - провайдер `seasonalControllerProvider` → `AsyncValue<SeasonalState>`.
/// - `build` грузит `GET /api/v1/me/seasonal` → [SeasonalState]. Ошибка
///   загрузки → `AsyncError(ApiError)` (UI: ErrorState + retry через
///   `ref.invalidate`).
/// - [toggle] оптимистично меняет тумблер и PATCH'ит `seasonalEnabled`. По
///   успеху фиксирует серверное состояние; по ошибке откатывает `enabled` и
///   кладёт `saveError` (UI: снэкбар). No-op, если уже идёт сохранение.
/// - [resetSeason] сбрасывает intervalDays сезона через DELETE.

abstract class _$SeasonalController extends $AsyncNotifier<SeasonalState> {
  FutureOr<SeasonalState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SeasonalState>, SeasonalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SeasonalState>, SeasonalState>,
              AsyncValue<SeasonalState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
