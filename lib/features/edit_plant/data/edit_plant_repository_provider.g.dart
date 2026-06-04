// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_plant_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [EditPlantRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `editPlantRepositoryProvider.overrideWith(...)`.

@ProviderFor(editPlantRepository)
final editPlantRepositoryProvider = EditPlantRepositoryProvider._();

/// DI-точка для [EditPlantRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `editPlantRepositoryProvider.overrideWith(...)`.

final class EditPlantRepositoryProvider
    extends
        $FunctionalProvider<
          EditPlantRepository,
          EditPlantRepository,
          EditPlantRepository
        >
    with $Provider<EditPlantRepository> {
  /// DI-точка для [EditPlantRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `editPlantRepositoryProvider.overrideWith(...)`.
  EditPlantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editPlantRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editPlantRepositoryHash();

  @$internal
  @override
  $ProviderElement<EditPlantRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EditPlantRepository create(Ref ref) {
    return editPlantRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditPlantRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditPlantRepository>(value),
    );
  }
}

String _$editPlantRepositoryHash() =>
    r'2b84e40039a39cbcbfbd101032a3b79d24b6ce80';
