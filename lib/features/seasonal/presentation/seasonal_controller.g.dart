// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(SeasonalController)
final seasonalControllerProvider = SeasonalControllerProvider._();

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
final class SeasonalControllerProvider
    extends $AsyncNotifierProvider<SeasonalController, SeasonalState> {
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
    r'b4b5207f9c9a00d6ad54ff5634ab481a4017e787';

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
