// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_card_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [PlantCardRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantCardRepositoryProvider.overrideWith(...)`.

@ProviderFor(plantCardRepository)
final plantCardRepositoryProvider = PlantCardRepositoryProvider._();

/// DI-точка для [PlantCardRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantCardRepositoryProvider.overrideWith(...)`.

final class PlantCardRepositoryProvider
    extends
        $FunctionalProvider<
          PlantCardRepository,
          PlantCardRepository,
          PlantCardRepository
        >
    with $Provider<PlantCardRepository> {
  /// DI-точка для [PlantCardRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `plantCardRepositoryProvider.overrideWith(...)`.
  PlantCardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantCardRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantCardRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantCardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantCardRepository create(Ref ref) {
    return plantCardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantCardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantCardRepository>(value),
    );
  }
}

String _$plantCardRepositoryHash() =>
    r'5cbe9fcb6a29f8348f0e526a3aa443a0beadebf9';
