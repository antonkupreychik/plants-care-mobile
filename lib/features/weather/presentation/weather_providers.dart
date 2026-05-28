import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/weather_repository_provider.dart';
import '../domain/weather_snapshot.dart';

part 'weather_providers.g.dart';

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
@riverpod
Future<WeatherSnapshot> weatherSnapshot(Ref ref) async {
  final result = await ref.watch(weatherRepositoryProvider).getSnapshot();
  return _unwrap(result);
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
