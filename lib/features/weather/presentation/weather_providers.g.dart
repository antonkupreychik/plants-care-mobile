// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой фичи «Погода на Home» (G4).
///
/// Контракт для ui-builder: провайдер отдаёт `AsyncValue<WeatherSnapshot>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
///
/// UI рисует строку погоды только когда `snapshot.hasData` (см.
/// [WeatherSnapshot.hasData]); при `available=false` строку не показывает.
/// Значения посчитаны backend, клиент рекомендацию не пересчитывает.
/// Снапшот погоды (`GET /weather/snapshot`, scope none — публичный).

@ProviderFor(weatherSnapshot)
final weatherSnapshotProvider = WeatherSnapshotProvider._();

/// State-слой фичи «Погода на Home» (G4).
///
/// Контракт для ui-builder: провайдер отдаёт `AsyncValue<WeatherSnapshot>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
///
/// UI рисует строку погоды только когда `snapshot.hasData` (см.
/// [WeatherSnapshot.hasData]); при `available=false` строку не показывает.
/// Значения посчитаны backend, клиент рекомендацию не пересчитывает.
/// Снапшот погоды (`GET /weather/snapshot`, scope none — публичный).

final class WeatherSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeatherSnapshot>,
          WeatherSnapshot,
          FutureOr<WeatherSnapshot>
        >
    with $FutureModifier<WeatherSnapshot>, $FutureProvider<WeatherSnapshot> {
  /// State-слой фичи «Погода на Home» (G4).
  ///
  /// Контракт для ui-builder: провайдер отдаёт `AsyncValue<WeatherSnapshot>`
  /// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
  /// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
  ///
  /// UI рисует строку погоды только когда `snapshot.hasData` (см.
  /// [WeatherSnapshot.hasData]); при `available=false` строку не показывает.
  /// Значения посчитаны backend, клиент рекомендацию не пересчитывает.
  /// Снапшот погоды (`GET /weather/snapshot`, scope none — публичный).
  WeatherSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<WeatherSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeatherSnapshot> create(Ref ref) {
    return weatherSnapshot(ref);
  }
}

String _$weatherSnapshotHash() => r'69bd733c1d9a7023471fd57ed19f043dba9bea4e';
