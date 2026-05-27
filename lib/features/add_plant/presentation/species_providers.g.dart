// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой справочника видов для мастера (шаг 1 + превью шага 3).
///
/// Контракт для ui-builder: оба провайдера отдают `AsyncValue<...>`
/// (loading / error / data); в `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
/// Поиск видов по строке запроса (family). Пустой запрос (`''`) → топ видов
/// (backend отдаёт без фильтра) — список не пустой при первом открытии шага 1.
///
/// Debounce ввода — забота UI (watch с уже «успокоившимся» запросом): провайдер
/// просто family по нормализованной строке, без таймеров в state.

@ProviderFor(speciesSearch)
final speciesSearchProvider = SpeciesSearchFamily._();

/// State-слой справочника видов для мастера (шаг 1 + превью шага 3).
///
/// Контракт для ui-builder: оба провайдера отдают `AsyncValue<...>`
/// (loading / error / data); в `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
/// Поиск видов по строке запроса (family). Пустой запрос (`''`) → топ видов
/// (backend отдаёт без фильтра) — список не пустой при первом открытии шага 1.
///
/// Debounce ввода — забота UI (watch с уже «успокоившимся» запросом): провайдер
/// просто family по нормализованной строке, без таймеров в state.

final class SpeciesSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SpeciesSummary>>,
          List<SpeciesSummary>,
          FutureOr<List<SpeciesSummary>>
        >
    with
        $FutureModifier<List<SpeciesSummary>>,
        $FutureProvider<List<SpeciesSummary>> {
  /// State-слой справочника видов для мастера (шаг 1 + превью шага 3).
  ///
  /// Контракт для ui-builder: оба провайдера отдают `AsyncValue<...>`
  /// (loading / error / data); в `AsyncError` лежит типизированный [ApiError]
  /// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
  /// Поиск видов по строке запроса (family). Пустой запрос (`''`) → топ видов
  /// (backend отдаёт без фильтра) — список не пустой при первом открытии шага 1.
  ///
  /// Debounce ввода — забота UI (watch с уже «успокоившимся» запросом): провайдер
  /// просто family по нормализованной строке, без таймеров в state.
  SpeciesSearchProvider._({
    required SpeciesSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'speciesSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speciesSearchHash();

  @override
  String toString() {
    return r'speciesSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SpeciesSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpeciesSummary>> create(Ref ref) {
    final argument = this.argument as String;
    return speciesSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpeciesSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speciesSearchHash() => r'e3d76049f35cf66fc6d13c8bc48474adba94cf2d';

/// State-слой справочника видов для мастера (шаг 1 + превью шага 3).
///
/// Контракт для ui-builder: оба провайдера отдают `AsyncValue<...>`
/// (loading / error / data); в `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
/// Поиск видов по строке запроса (family). Пустой запрос (`''`) → топ видов
/// (backend отдаёт без фильтра) — список не пустой при первом открытии шага 1.
///
/// Debounce ввода — забота UI (watch с уже «успокоившимся» запросом): провайдер
/// просто family по нормализованной строке, без таймеров в state.

final class SpeciesSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SpeciesSummary>>, String> {
  SpeciesSearchFamily._()
    : super(
        retry: null,
        name: r'speciesSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State-слой справочника видов для мастера (шаг 1 + превью шага 3).
  ///
  /// Контракт для ui-builder: оба провайдера отдают `AsyncValue<...>`
  /// (loading / error / data); в `AsyncError` лежит типизированный [ApiError]
  /// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
  /// Поиск видов по строке запроса (family). Пустой запрос (`''`) → топ видов
  /// (backend отдаёт без фильтра) — список не пустой при первом открытии шага 1.
  ///
  /// Debounce ввода — забота UI (watch с уже «успокоившимся» запросом): провайдер
  /// просто family по нормализованной строке, без таймеров в state.

  SpeciesSearchProvider call(String query) =>
      SpeciesSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'speciesSearchProvider';
}

/// Детали вида по id (family) — нужны на превью ради `description`. Интервалы
/// для «плана ухода» уже есть в выбранном [SpeciesSummary] (см. wizard-контроллер),
/// так что этот запрос делается лениво и только когда UI показывает описание.

@ProviderFor(speciesDetail)
final speciesDetailProvider = SpeciesDetailFamily._();

/// Детали вида по id (family) — нужны на превью ради `description`. Интервалы
/// для «плана ухода» уже есть в выбранном [SpeciesSummary] (см. wizard-контроллер),
/// так что этот запрос делается лениво и только когда UI показывает описание.

final class SpeciesDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SpeciesDetail>,
          SpeciesDetail,
          FutureOr<SpeciesDetail>
        >
    with $FutureModifier<SpeciesDetail>, $FutureProvider<SpeciesDetail> {
  /// Детали вида по id (family) — нужны на превью ради `description`. Интервалы
  /// для «плана ухода» уже есть в выбранном [SpeciesSummary] (см. wizard-контроллер),
  /// так что этот запрос делается лениво и только когда UI показывает описание.
  SpeciesDetailProvider._({
    required SpeciesDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'speciesDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speciesDetailHash();

  @override
  String toString() {
    return r'speciesDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SpeciesDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SpeciesDetail> create(Ref ref) {
    final argument = this.argument as int;
    return speciesDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpeciesDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speciesDetailHash() => r'f5cbbddc9774f27bea56cb901d10216fc32c4140';

/// Детали вида по id (family) — нужны на превью ради `description`. Интервалы
/// для «плана ухода» уже есть в выбранном [SpeciesSummary] (см. wizard-контроллер),
/// так что этот запрос делается лениво и только когда UI показывает описание.

final class SpeciesDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SpeciesDetail>, int> {
  SpeciesDetailFamily._()
    : super(
        retry: null,
        name: r'speciesDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Детали вида по id (family) — нужны на превью ради `description`. Интервалы
  /// для «плана ухода» уже есть в выбранном [SpeciesSummary] (см. wizard-контроллер),
  /// так что этот запрос делается лениво и только когда UI показывает описание.

  SpeciesDetailProvider call(int id) =>
      SpeciesDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'speciesDetailProvider';
}
