// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_catalog_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
///
/// Использует реальную реализацию [DiseaseCatalogRepositoryImpl] поверх
/// `DiseasesClient` (issue #150). В тестах подменяется через
/// `diseaseCatalogRepositoryProvider.overrideWith(...)`.

@ProviderFor(diseaseCatalogRepository)
final diseaseCatalogRepositoryProvider = DiseaseCatalogRepositoryProvider._();

/// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
///
/// Использует реальную реализацию [DiseaseCatalogRepositoryImpl] поверх
/// `DiseasesClient` (issue #150). В тестах подменяется через
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
  /// Использует реальную реализацию [DiseaseCatalogRepositoryImpl] поверх
  /// `DiseasesClient` (issue #150). В тестах подменяется через
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
    r'd024d8c59c3d7496e5a91a66ad7ee6ec44b8f397';
