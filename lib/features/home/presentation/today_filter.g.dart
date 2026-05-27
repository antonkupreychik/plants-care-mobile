// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UI-состояние: выбранная пилюля-фильтр на экране 03. Дефолт — [TodayFilter.all].
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с экрана фильтр сбрасывается на «Всё» (по образцу
/// [SelectedLocation] из `home_filter.dart`). Сама фильтрация делается чистой
/// функцией в `today_view.dart` над уже загруженным из `homeTasksProvider`
/// списком — без сети.

@ProviderFor(SelectedTodayFilter)
final selectedTodayFilterProvider = SelectedTodayFilterProvider._();

/// UI-состояние: выбранная пилюля-фильтр на экране 03. Дефолт — [TodayFilter.all].
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с экрана фильтр сбрасывается на «Всё» (по образцу
/// [SelectedLocation] из `home_filter.dart`). Сама фильтрация делается чистой
/// функцией в `today_view.dart` над уже загруженным из `homeTasksProvider`
/// списком — без сети.
final class SelectedTodayFilterProvider
    extends $NotifierProvider<SelectedTodayFilter, TodayFilter> {
  /// UI-состояние: выбранная пилюля-фильтр на экране 03. Дефолт — [TodayFilter.all].
  ///
  /// Presentation-only (выбор чипа), не доменные данные. Через codegen —
  /// **autoDispose**: при уходе с экрана фильтр сбрасывается на «Всё» (по образцу
  /// [SelectedLocation] из `home_filter.dart`). Сама фильтрация делается чистой
  /// функцией в `today_view.dart` над уже загруженным из `homeTasksProvider`
  /// списком — без сети.
  SelectedTodayFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTodayFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTodayFilterHash();

  @$internal
  @override
  SelectedTodayFilter create() => SelectedTodayFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodayFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodayFilter>(value),
    );
  }
}

String _$selectedTodayFilterHash() =>
    r'5943ccc97bae6a381db98d9cb372446c6950f4a0';

/// UI-состояние: выбранная пилюля-фильтр на экране 03. Дефолт — [TodayFilter.all].
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с экрана фильтр сбрасывается на «Всё» (по образцу
/// [SelectedLocation] из `home_filter.dart`). Сама фильтрация делается чистой
/// функцией в `today_view.dart` над уже загруженным из `homeTasksProvider`
/// списком — без сети.

abstract class _$SelectedTodayFilter extends $Notifier<TodayFilter> {
  TodayFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TodayFilter, TodayFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TodayFilter, TodayFilter>,
              TodayFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
