// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Текущая строка поиска по каталогу (committed-значение, не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer), сюда кладётся уже «успокоившееся» значение через [setQuery].
/// `keepAlive`: строка переживает уход с экрана списка на деталь и обратно
/// (пользователь возвращается к тем же результатам). Сброс — `setQuery('')`.

@ProviderFor(SpeciesQuery)
final speciesQueryProvider = SpeciesQueryProvider._();

/// Текущая строка поиска по каталогу (committed-значение, не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer), сюда кладётся уже «успокоившееся» значение через [setQuery].
/// `keepAlive`: строка переживает уход с экрана списка на деталь и обратно
/// (пользователь возвращается к тем же результатам). Сброс — `setQuery('')`.
final class SpeciesQueryProvider
    extends $NotifierProvider<SpeciesQuery, String> {
  /// Текущая строка поиска по каталогу (committed-значение, не сырой ввод).
  ///
  /// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
  /// (Timer), сюда кладётся уже «успокоившееся» значение через [setQuery].
  /// `keepAlive`: строка переживает уход с экрана списка на деталь и обратно
  /// (пользователь возвращается к тем же результатам). Сброс — `setQuery('')`.
  SpeciesQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speciesQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speciesQueryHash();

  @$internal
  @override
  SpeciesQuery create() => SpeciesQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$speciesQueryHash() => r'f23edec54aea19a452fec0a3d7533172ede2c1d6';

/// Текущая строка поиска по каталогу (committed-значение, не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer), сюда кладётся уже «успокоившееся» значение через [setQuery].
/// `keepAlive`: строка переживает уход с экрана списка на деталь и обратно
/// (пользователь возвращается к тем же результатам). Сброс — `setQuery('')`.

abstract class _$SpeciesQuery extends $Notifier<String> {
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

/// Аккумулирующий пагинированный список видов под текущей строкой поиска.
///
/// `watch(speciesQueryProvider)` в [build]: смена строки поиска пересоздаёт
/// нотифаер (Riverpod сбрасывает state в loading) и грузит первую страницу с
/// начала — отдельный reset не нужен. Дальше [loadMore] дозагружает страницы и
/// **аккумулирует** их в [SpeciesListState.items], пока `hasMore` (по `total`
/// из `PageResponse`).

@ProviderFor(SpeciesList)
final speciesListProvider = SpeciesListProvider._();

/// Аккумулирующий пагинированный список видов под текущей строкой поиска.
///
/// `watch(speciesQueryProvider)` в [build]: смена строки поиска пересоздаёт
/// нотифаер (Riverpod сбрасывает state в loading) и грузит первую страницу с
/// начала — отдельный reset не нужен. Дальше [loadMore] дозагружает страницы и
/// **аккумулирует** их в [SpeciesListState.items], пока `hasMore` (по `total`
/// из `PageResponse`).
final class SpeciesListProvider
    extends $AsyncNotifierProvider<SpeciesList, SpeciesListState> {
  /// Аккумулирующий пагинированный список видов под текущей строкой поиска.
  ///
  /// `watch(speciesQueryProvider)` в [build]: смена строки поиска пересоздаёт
  /// нотифаер (Riverpod сбрасывает state в loading) и грузит первую страницу с
  /// начала — отдельный reset не нужен. Дальше [loadMore] дозагружает страницы и
  /// **аккумулирует** их в [SpeciesListState.items], пока `hasMore` (по `total`
  /// из `PageResponse`).
  SpeciesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speciesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speciesListHash();

  @$internal
  @override
  SpeciesList create() => SpeciesList();
}

String _$speciesListHash() => r'f67d55ecfe16bca85a4739757b7118abda889c0a';

/// Аккумулирующий пагинированный список видов под текущей строкой поиска.
///
/// `watch(speciesQueryProvider)` в [build]: смена строки поиска пересоздаёт
/// нотифаер (Riverpod сбрасывает state в loading) и грузит первую страницу с
/// начала — отдельный reset не нужен. Дальше [loadMore] дозагружает страницы и
/// **аккумулирует** их в [SpeciesListState.items], пока `hasMore` (по `total`
/// из `PageResponse`).

abstract class _$SpeciesList extends $AsyncNotifier<SpeciesListState> {
  FutureOr<SpeciesListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SpeciesListState>, SpeciesListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpeciesListState>, SpeciesListState>,
              AsyncValue<SpeciesListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Деталь вида (`GET /api/v1/species/{id}`, scope none). Family по `id`,
/// как `plantDetailProvider`. `AsyncError` несёт типизированный `ApiError`.

@ProviderFor(speciesDetail)
final speciesDetailProvider = SpeciesDetailFamily._();

/// Деталь вида (`GET /api/v1/species/{id}`, scope none). Family по `id`,
/// как `plantDetailProvider`. `AsyncError` несёт типизированный `ApiError`.

final class SpeciesDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SpeciesDetail>,
          SpeciesDetail,
          FutureOr<SpeciesDetail>
        >
    with $FutureModifier<SpeciesDetail>, $FutureProvider<SpeciesDetail> {
  /// Деталь вида (`GET /api/v1/species/{id}`, scope none). Family по `id`,
  /// как `plantDetailProvider`. `AsyncError` несёт типизированный `ApiError`.
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

String _$speciesDetailHash() => r'ddb879c380d572d23f5202d7dffa40fb782c828b';

/// Деталь вида (`GET /api/v1/species/{id}`, scope none). Family по `id`,
/// как `plantDetailProvider`. `AsyncError` несёт типизированный `ApiError`.

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

  /// Деталь вида (`GET /api/v1/species/{id}`, scope none). Family по `id`,
  /// как `plantDetailProvider`. `AsyncError` несёт типизированный `ApiError`.

  SpeciesDetailProvider call(int id) =>
      SpeciesDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'speciesDetailProvider';
}
