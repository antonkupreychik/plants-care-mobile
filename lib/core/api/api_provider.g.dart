// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Сгенерированный API-клиент (MADR-007) поверх общего [Dio] с интерсепторами
/// (auth-scope, маппинг ошибок, ретраи — MADR-006). Репозитории фич берут
/// нужный под-клиент: `ref.watch(plantsCareApiProvider).plants.listPlants(...)`.

@ProviderFor(plantsCareApi)
final plantsCareApiProvider = PlantsCareApiProvider._();

/// Сгенерированный API-клиент (MADR-007) поверх общего [Dio] с интерсепторами
/// (auth-scope, маппинг ошибок, ретраи — MADR-006). Репозитории фич берут
/// нужный под-клиент: `ref.watch(plantsCareApiProvider).plants.listPlants(...)`.

final class PlantsCareApiProvider
    extends $FunctionalProvider<PlantsCareApi, PlantsCareApi, PlantsCareApi>
    with $Provider<PlantsCareApi> {
  /// Сгенерированный API-клиент (MADR-007) поверх общего [Dio] с интерсепторами
  /// (auth-scope, маппинг ошибок, ретраи — MADR-006). Репозитории фич берут
  /// нужный под-клиент: `ref.watch(plantsCareApiProvider).plants.listPlants(...)`.
  PlantsCareApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantsCareApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantsCareApiHash();

  @$internal
  @override
  $ProviderElement<PlantsCareApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlantsCareApi create(Ref ref) {
    return plantsCareApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantsCareApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantsCareApi>(value),
    );
  }
}

String _$plantsCareApiHash() => r'2ab2fa237958a9bc7633f7d9770024ab421a9170';
