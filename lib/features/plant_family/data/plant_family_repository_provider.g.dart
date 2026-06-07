// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_family_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [PlantFamilyRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantFamilyRepositoryProvider.overrideWith(...)`.

@ProviderFor(plantFamilyRepository)
final plantFamilyRepositoryProvider = PlantFamilyRepositoryProvider._();

/// DI-точка для [PlantFamilyRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantFamilyRepositoryProvider.overrideWith(...)`.

final class PlantFamilyRepositoryProvider
    extends
        $FunctionalProvider<
          PlantFamilyRepository,
          PlantFamilyRepository,
          PlantFamilyRepository
        >
    with $Provider<PlantFamilyRepository> {
  /// DI-точка для [PlantFamilyRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `plantFamilyRepositoryProvider.overrideWith(...)`.
  PlantFamilyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantFamilyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantFamilyRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantFamilyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantFamilyRepository create(Ref ref) {
    return plantFamilyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantFamilyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantFamilyRepository>(value),
    );
  }
}

String _$plantFamilyRepositoryHash() =>
    r'9d4e2933a940d7833d8ecd48abc6223f5e2eb624';
