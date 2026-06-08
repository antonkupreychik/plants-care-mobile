// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_event_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
///
/// Отдаёт [PlantEventRepositoryImpl] поверх сгенерированного `PlantEventsClient`
/// (`GET/POST /plants/{id}/events`, backend #220), как `careEventRepository`.
/// В тестах подменяется через `plantEventRepositoryProvider.overrideWith(...)`.

@ProviderFor(plantEventRepository)
final plantEventRepositoryProvider = PlantEventRepositoryProvider._();

/// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
///
/// Отдаёт [PlantEventRepositoryImpl] поверх сгенерированного `PlantEventsClient`
/// (`GET/POST /plants/{id}/events`, backend #220), как `careEventRepository`.
/// В тестах подменяется через `plantEventRepositoryProvider.overrideWith(...)`.

final class PlantEventRepositoryProvider
    extends
        $FunctionalProvider<
          PlantEventRepository,
          PlantEventRepository,
          PlantEventRepository
        >
    with $Provider<PlantEventRepository> {
  /// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// Отдаёт [PlantEventRepositoryImpl] поверх сгенерированного `PlantEventsClient`
  /// (`GET/POST /plants/{id}/events`, backend #220), как `careEventRepository`.
  /// В тестах подменяется через `plantEventRepositoryProvider.overrideWith(...)`.
  PlantEventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantEventRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantEventRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantEventRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantEventRepository create(Ref ref) {
    return plantEventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantEventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantEventRepository>(value),
    );
  }
}

String _$plantEventRepositoryHash() =>
    r'b3e10cc1900364168f1469414e85c74032913dfa';
