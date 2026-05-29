import '../../../core/error/result.dart';
import 'weather_snapshot.dart';

/// Контракт data-слоя для фичи «Погода на Home» (G4).
///
/// Одно чтение — снапшот погоды (`GET /weather/snapshot`, scope none —
/// эндпоинт публичный, идентичность не требуется). Значения посчитаны backend,
/// клиент их не пересчитывает. Возвращает `Future<Result<T>>` и НЕ бросает
/// наружу (MADR-011).
abstract interface class WeatherRepository {
  /// Снапшот погоды (`GET /weather/snapshot`, scope none).
  Future<Result<WeatherSnapshot>> getSnapshot();
}
