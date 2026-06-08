// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Текущая committed-строка поиска (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer 400 мс), сюда кладётся уже «успокоившееся» trim'нутое значение.
/// autoDispose (дефолт): строка живёт пока открыт экран поиска, сброс при выходе.

@ProviderFor(UnifiedSearchQuery)
final unifiedSearchQueryProvider = UnifiedSearchQueryProvider._();

/// Текущая committed-строка поиска (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer 400 мс), сюда кладётся уже «успокоившееся» trim'нутое значение.
/// autoDispose (дефолт): строка живёт пока открыт экран поиска, сброс при выходе.
final class UnifiedSearchQueryProvider
    extends $NotifierProvider<UnifiedSearchQuery, String> {
  /// Текущая committed-строка поиска (не сырой ввод).
  ///
  /// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
  /// (Timer 400 мс), сюда кладётся уже «успокоившееся» trim'нутое значение.
  /// autoDispose (дефолт): строка живёт пока открыт экран поиска, сброс при выходе.
  UnifiedSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unifiedSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unifiedSearchQueryHash();

  @$internal
  @override
  UnifiedSearchQuery create() => UnifiedSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$unifiedSearchQueryHash() =>
    r'd9ffe1bc4acf78c6b74eeef4382f1f75e7a7c280';

/// Текущая committed-строка поиска (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer 400 мс), сюда кладётся уже «успокоившееся» trim'нутое значение.
/// autoDispose (дефолт): строка живёт пока открыт экран поиска, сброс при выходе.

abstract class _$UnifiedSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Результаты раздела «Мои растения» — клиентская фильтрация
/// [homePlantsProvider] по `plant.name` (contains, ignoreCase), максимум
/// [kPlantResultsLimit]. Запрос короче [kSearchMinChars] → пустой список.
///
/// Не делает отдельного сетевого запроса: переиспользует уже загруженный (с
/// лимитом 50) список растений Home. `AsyncError`/`loading` прокидываются как
/// есть — секция нарисует skeleton/ошибку.

@ProviderFor(plantSearchResults)
final plantSearchResultsProvider = PlantSearchResultsFamily._();

/// Результаты раздела «Мои растения» — клиентская фильтрация
/// [homePlantsProvider] по `plant.name` (contains, ignoreCase), максимум
/// [kPlantResultsLimit]. Запрос короче [kSearchMinChars] → пустой список.
///
/// Не делает отдельного сетевого запроса: переиспользует уже загруженный (с
/// лимитом 50) список растений Home. `AsyncError`/`loading` прокидываются как
/// есть — секция нарисует skeleton/ошибку.

final class PlantSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Plant>>,
          List<Plant>,
          FutureOr<List<Plant>>
        >
    with $FutureModifier<List<Plant>>, $FutureProvider<List<Plant>> {
  /// Результаты раздела «Мои растения» — клиентская фильтрация
  /// [homePlantsProvider] по `plant.name` (contains, ignoreCase), максимум
  /// [kPlantResultsLimit]. Запрос короче [kSearchMinChars] → пустой список.
  ///
  /// Не делает отдельного сетевого запроса: переиспользует уже загруженный (с
  /// лимитом 50) список растений Home. `AsyncError`/`loading` прокидываются как
  /// есть — секция нарисует skeleton/ошибку.
  PlantSearchResultsProvider._({
    required PlantSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'plantSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantSearchResultsHash();

  @override
  String toString() {
    return r'plantSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Plant>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Plant>> create(Ref ref) {
    final argument = this.argument as String;
    return plantSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantSearchResultsHash() =>
    r'91ed5cea122bde3db6729cf1f5e10afd025c7b28';

/// Результаты раздела «Мои растения» — клиентская фильтрация
/// [homePlantsProvider] по `plant.name` (contains, ignoreCase), максимум
/// [kPlantResultsLimit]. Запрос короче [kSearchMinChars] → пустой список.
///
/// Не делает отдельного сетевого запроса: переиспользует уже загруженный (с
/// лимитом 50) список растений Home. `AsyncError`/`loading` прокидываются как
/// есть — секция нарисует skeleton/ошибку.

final class PlantSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Plant>>, String> {
  PlantSearchResultsFamily._()
    : super(
        retry: null,
        name: r'plantSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Результаты раздела «Мои растения» — клиентская фильтрация
  /// [homePlantsProvider] по `plant.name` (contains, ignoreCase), максимум
  /// [kPlantResultsLimit]. Запрос короче [kSearchMinChars] → пустой список.
  ///
  /// Не делает отдельного сетевого запроса: переиспользует уже загруженный (с
  /// лимитом 50) список растений Home. `AsyncError`/`loading` прокидываются как
  /// есть — секция нарисует skeleton/ошибку.

  PlantSearchResultsProvider call(String query) =>
      PlantSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'plantSearchResultsProvider';
}

/// Результаты раздела «Виды» — `GET /species?q=&limit=5` через
/// [catalogRepositoryProvider]. Запрос короче [kSearchMinChars] → пустой список
/// (сетевой запрос не уходит). Ошибка репозитория пробрасывается в `AsyncError`.

@ProviderFor(speciesSearchResults)
final speciesSearchResultsProvider = SpeciesSearchResultsFamily._();

/// Результаты раздела «Виды» — `GET /species?q=&limit=5` через
/// [catalogRepositoryProvider]. Запрос короче [kSearchMinChars] → пустой список
/// (сетевой запрос не уходит). Ошибка репозитория пробрасывается в `AsyncError`.

final class SpeciesSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Species>>,
          List<Species>,
          FutureOr<List<Species>>
        >
    with $FutureModifier<List<Species>>, $FutureProvider<List<Species>> {
  /// Результаты раздела «Виды» — `GET /species?q=&limit=5` через
  /// [catalogRepositoryProvider]. Запрос короче [kSearchMinChars] → пустой список
  /// (сетевой запрос не уходит). Ошибка репозитория пробрасывается в `AsyncError`.
  SpeciesSearchResultsProvider._({
    required SpeciesSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'speciesSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speciesSearchResultsHash();

  @override
  String toString() {
    return r'speciesSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Species>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Species>> create(Ref ref) {
    final argument = this.argument as String;
    return speciesSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpeciesSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speciesSearchResultsHash() =>
    r'9eccf3fa3d6589adb5e5edd58f6b72ebdadc449c';

/// Результаты раздела «Виды» — `GET /species?q=&limit=5` через
/// [catalogRepositoryProvider]. Запрос короче [kSearchMinChars] → пустой список
/// (сетевой запрос не уходит). Ошибка репозитория пробрасывается в `AsyncError`.

final class SpeciesSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Species>>, String> {
  SpeciesSearchResultsFamily._()
    : super(
        retry: null,
        name: r'speciesSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Результаты раздела «Виды» — `GET /species?q=&limit=5` через
  /// [catalogRepositoryProvider]. Запрос короче [kSearchMinChars] → пустой список
  /// (сетевой запрос не уходит). Ошибка репозитория пробрасывается в `AsyncError`.

  SpeciesSearchResultsProvider call(String query) =>
      SpeciesSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'speciesSearchResultsProvider';
}

/// Результаты раздела «Болезни и вредители» — `GET /diseases?q=` через
/// [diseaseCatalogRepositoryProvider] (полнотекстовый поиск на стороне backend).
/// Запрос короче [kSearchMinChars] → пустой список (сетевой запрос не уходит).
/// Ошибка репозитория пробрасывается в `AsyncError`.
///
/// Полная доменная модель справочника (`disease_catalog/domain/disease.dart`)
/// маппится в лёгкую `search/domain/Disease` (только id/name/latinName), которой
/// достаточно секции поиска; результат обрезается до [kSearchResultsLimit].

@ProviderFor(diseaseSearchResults)
final diseaseSearchResultsProvider = DiseaseSearchResultsFamily._();

/// Результаты раздела «Болезни и вредители» — `GET /diseases?q=` через
/// [diseaseCatalogRepositoryProvider] (полнотекстовый поиск на стороне backend).
/// Запрос короче [kSearchMinChars] → пустой список (сетевой запрос не уходит).
/// Ошибка репозитория пробрасывается в `AsyncError`.
///
/// Полная доменная модель справочника (`disease_catalog/domain/disease.dart`)
/// маппится в лёгкую `search/domain/Disease` (только id/name/latinName), которой
/// достаточно секции поиска; результат обрезается до [kSearchResultsLimit].

final class DiseaseSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Disease>>,
          List<Disease>,
          FutureOr<List<Disease>>
        >
    with $FutureModifier<List<Disease>>, $FutureProvider<List<Disease>> {
  /// Результаты раздела «Болезни и вредители» — `GET /diseases?q=` через
  /// [diseaseCatalogRepositoryProvider] (полнотекстовый поиск на стороне backend).
  /// Запрос короче [kSearchMinChars] → пустой список (сетевой запрос не уходит).
  /// Ошибка репозитория пробрасывается в `AsyncError`.
  ///
  /// Полная доменная модель справочника (`disease_catalog/domain/disease.dart`)
  /// маппится в лёгкую `search/domain/Disease` (только id/name/latinName), которой
  /// достаточно секции поиска; результат обрезается до [kSearchResultsLimit].
  DiseaseSearchResultsProvider._({
    required DiseaseSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'diseaseSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diseaseSearchResultsHash();

  @override
  String toString() {
    return r'diseaseSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Disease>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Disease>> create(Ref ref) {
    final argument = this.argument as String;
    return diseaseSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiseaseSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diseaseSearchResultsHash() =>
    r'363b8589762f566595426d6c7eef8ea306674d62';

/// Результаты раздела «Болезни и вредители» — `GET /diseases?q=` через
/// [diseaseCatalogRepositoryProvider] (полнотекстовый поиск на стороне backend).
/// Запрос короче [kSearchMinChars] → пустой список (сетевой запрос не уходит).
/// Ошибка репозитория пробрасывается в `AsyncError`.
///
/// Полная доменная модель справочника (`disease_catalog/domain/disease.dart`)
/// маппится в лёгкую `search/domain/Disease` (только id/name/latinName), которой
/// достаточно секции поиска; результат обрезается до [kSearchResultsLimit].

final class DiseaseSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Disease>>, String> {
  DiseaseSearchResultsFamily._()
    : super(
        retry: null,
        name: r'diseaseSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Результаты раздела «Болезни и вредители» — `GET /diseases?q=` через
  /// [diseaseCatalogRepositoryProvider] (полнотекстовый поиск на стороне backend).
  /// Запрос короче [kSearchMinChars] → пустой список (сетевой запрос не уходит).
  /// Ошибка репозитория пробрасывается в `AsyncError`.
  ///
  /// Полная доменная модель справочника (`disease_catalog/domain/disease.dart`)
  /// маппится в лёгкую `search/domain/Disease` (только id/name/latinName), которой
  /// достаточно секции поиска; результат обрезается до [kSearchResultsLimit].

  DiseaseSearchResultsProvider call(String query) =>
      DiseaseSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'diseaseSearchResultsProvider';
}
