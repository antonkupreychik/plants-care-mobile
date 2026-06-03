// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiet_hours_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(QuietHoursController)
final quietHoursControllerProvider = QuietHoursControllerProvider._();

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
final class QuietHoursControllerProvider
    extends $AsyncNotifierProvider<QuietHoursController, QuietHoursState> {
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
  QuietHoursControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quietHoursControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quietHoursControllerHash();

  @$internal
  @override
  QuietHoursController create() => QuietHoursController();
}

String _$quietHoursControllerHash() =>
    r'cb0c728d0a18592a45531b89222b6a91f59858ac';

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

abstract class _$QuietHoursController extends $AsyncNotifier<QuietHoursState> {
  FutureOr<QuietHoursState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<QuietHoursState>, QuietHoursState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QuietHoursState>, QuietHoursState>,
              AsyncValue<QuietHoursState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
