// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [WeatherRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `weatherRepositoryProvider.overrideWith(...)`.

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

/// DI-точка для [WeatherRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `weatherRepositoryProvider.overrideWith(...)`.

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  /// DI-точка для [WeatherRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `weatherRepositoryProvider.overrideWith(...)`.
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'471883bb4fb14b1647e81fdaebfc21b24235cdf4';
