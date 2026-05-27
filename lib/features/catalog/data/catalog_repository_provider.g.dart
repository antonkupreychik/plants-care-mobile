// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [CatalogRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `catalogRepositoryProvider.overrideWith(...)`.

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

/// DI-точка для [CatalogRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `catalogRepositoryProvider.overrideWith(...)`.

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  /// DI-точка для [CatalogRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `catalogRepositoryProvider.overrideWith(...)`.
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'8466c979721b0c59f1e9e89d1a821372696a6611';
