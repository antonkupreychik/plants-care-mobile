// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_template_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [PlantTemplateRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantTemplateRepositoryProvider.overrideWith(...)`.

@ProviderFor(plantTemplateRepository)
final plantTemplateRepositoryProvider = PlantTemplateRepositoryProvider._();

/// DI-точка для [PlantTemplateRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantTemplateRepositoryProvider.overrideWith(...)`.

final class PlantTemplateRepositoryProvider
    extends
        $FunctionalProvider<
          PlantTemplateRepository,
          PlantTemplateRepository,
          PlantTemplateRepository
        >
    with $Provider<PlantTemplateRepository> {
  /// DI-точка для [PlantTemplateRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `plantTemplateRepositoryProvider.overrideWith(...)`.
  PlantTemplateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantTemplateRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantTemplateRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantTemplateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantTemplateRepository create(Ref ref) {
    return plantTemplateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantTemplateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantTemplateRepository>(value),
    );
  }
}

String _$plantTemplateRepositoryHash() =>
    r'3d0880870a9d38436041896f325db478589c57c8';
