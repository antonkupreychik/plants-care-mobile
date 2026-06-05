// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_catalog_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
///
/// Пока backend-эндпоинты не готовы (`plants-care#225`) — отдаёт
/// [FakeDiseaseCatalogRepositoryImpl]. После регена OpenAPI-клиента здесь
/// меняется только реализация (`DiseaseCatalogRepositoryImpl`), контракт
/// провайдера и presentation не трогаются. В тестах подменяется через
/// `diseaseCatalogRepositoryProvider.overrideWith(...)`.

@ProviderFor(diseaseCatalogRepository)
final diseaseCatalogRepositoryProvider = DiseaseCatalogRepositoryProvider._();

/// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
///
/// Пока backend-эндпоинты не готовы (`plants-care#225`) — отдаёт
/// [FakeDiseaseCatalogRepositoryImpl]. После регена OpenAPI-клиента здесь
/// меняется только реализация (`DiseaseCatalogRepositoryImpl`), контракт
/// провайдера и presentation не трогаются. В тестах подменяется через
/// `diseaseCatalogRepositoryProvider.overrideWith(...)`.

final class DiseaseCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          DiseaseCatalogRepository,
          DiseaseCatalogRepository,
          DiseaseCatalogRepository
        >
    with $Provider<DiseaseCatalogRepository> {
  /// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// Пока backend-эндпоинты не готовы (`plants-care#225`) — отдаёт
  /// [FakeDiseaseCatalogRepositoryImpl]. После регена OpenAPI-клиента здесь
  /// меняется только реализация (`DiseaseCatalogRepositoryImpl`), контракт
  /// провайдера и presentation не трогаются. В тестах подменяется через
  /// `diseaseCatalogRepositoryProvider.overrideWith(...)`.
  DiseaseCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diseaseCatalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diseaseCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiseaseCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiseaseCatalogRepository create(Ref ref) {
    return diseaseCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiseaseCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiseaseCatalogRepository>(value),
    );
  }
}

String _$diseaseCatalogRepositoryHash() =>
    r'8c6d05071bcadeba7071470b55082590c014351b';
