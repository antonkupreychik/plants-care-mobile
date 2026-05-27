// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана 03 «Сегодня» — производный от Home, БЕЗ своего data-слоя.
///
/// Watch'ит:
///  * `homeTasksProvider` (`GET /today`) — тот же источник, что у Home-карточки.
///    Поэтому после отметки ухода (sheet 06 инвалидирует `homeTasksProvider`)
///    список здесь обновляется сам;
///  * `clockProvider` — текущий момент, переведённый в local (как на Home);
///  * `selectedTodayFilterProvider` — активная пилюля.
///
/// Деривацию делает чистая [buildTodayView] (в `today_view.dart`, тестируется
/// отдельно без Riverpod) — провайдер лишь собирает входы и прокидывает их.
///
/// Контракт для ui-builder: `AsyncValue<TodayView>` (loading / error / data).
/// В `AsyncError` — типизированный `ApiError` (проброшен из `homeTasksProvider`),
/// UI маппит его в текст через `AppLocalizations`.

@ProviderFor(todayView)
final todayViewProvider = TodayViewProvider._();

/// State-слой экрана 03 «Сегодня» — производный от Home, БЕЗ своего data-слоя.
///
/// Watch'ит:
///  * `homeTasksProvider` (`GET /today`) — тот же источник, что у Home-карточки.
///    Поэтому после отметки ухода (sheet 06 инвалидирует `homeTasksProvider`)
///    список здесь обновляется сам;
///  * `clockProvider` — текущий момент, переведённый в local (как на Home);
///  * `selectedTodayFilterProvider` — активная пилюля.
///
/// Деривацию делает чистая [buildTodayView] (в `today_view.dart`, тестируется
/// отдельно без Riverpod) — провайдер лишь собирает входы и прокидывает их.
///
/// Контракт для ui-builder: `AsyncValue<TodayView>` (loading / error / data).
/// В `AsyncError` — типизированный `ApiError` (проброшен из `homeTasksProvider`),
/// UI маппит его в текст через `AppLocalizations`.

final class TodayViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayView>,
          TodayView,
          FutureOr<TodayView>
        >
    with $FutureModifier<TodayView>, $FutureProvider<TodayView> {
  /// State-слой экрана 03 «Сегодня» — производный от Home, БЕЗ своего data-слоя.
  ///
  /// Watch'ит:
  ///  * `homeTasksProvider` (`GET /today`) — тот же источник, что у Home-карточки.
  ///    Поэтому после отметки ухода (sheet 06 инвалидирует `homeTasksProvider`)
  ///    список здесь обновляется сам;
  ///  * `clockProvider` — текущий момент, переведённый в local (как на Home);
  ///  * `selectedTodayFilterProvider` — активная пилюля.
  ///
  /// Деривацию делает чистая [buildTodayView] (в `today_view.dart`, тестируется
  /// отдельно без Riverpod) — провайдер лишь собирает входы и прокидывает их.
  ///
  /// Контракт для ui-builder: `AsyncValue<TodayView>` (loading / error / data).
  /// В `AsyncError` — типизированный `ApiError` (проброшен из `homeTasksProvider`),
  /// UI маппит его в текст через `AppLocalizations`.
  TodayViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayViewHash();

  @$internal
  @override
  $FutureProviderElement<TodayView> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodayView> create(Ref ref) {
    return todayView(ref);
  }
}

String _$todayViewHash() => r'b5ba0bebf94717f1c4bd567a905731735a4fb30d';
