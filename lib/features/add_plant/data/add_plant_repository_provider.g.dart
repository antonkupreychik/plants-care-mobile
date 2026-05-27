// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_plant_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [AddPlantRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `addPlantRepositoryProvider.overrideWith(...)`.

@ProviderFor(addPlantRepository)
final addPlantRepositoryProvider = AddPlantRepositoryProvider._();

/// DI-точка для [AddPlantRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `addPlantRepositoryProvider.overrideWith(...)`.

final class AddPlantRepositoryProvider
    extends
        $FunctionalProvider<
          AddPlantRepository,
          AddPlantRepository,
          AddPlantRepository
        >
    with $Provider<AddPlantRepository> {
  /// DI-точка для [AddPlantRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `addPlantRepositoryProvider.overrideWith(...)`.
  AddPlantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addPlantRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addPlantRepositoryHash();

  @$internal
  @override
  $ProviderElement<AddPlantRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddPlantRepository create(Ref ref) {
    return addPlantRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddPlantRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddPlantRepository>(value),
    );
  }
}

String _$addPlantRepositoryHash() =>
    r'6b5d340fbda5a7daebb9688b8d3ecf28cd06940d';
