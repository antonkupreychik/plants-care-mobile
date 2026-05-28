import '../../../../core/api/generated/models/plant_health_response.dart';
import '../../../../core/api/generated/models/plant_health_response_zone.dart';
import '../../domain/health_zone.dart';
import '../../domain/plant_health.dart';

/// Маппинг [PlantHealthResponse] (`/plants/{id}/health`) → domain [PlantHealth]
/// (MADR-002/007). Делаем руками — сгенерированный код не правим.
///
/// `score`/`zone`/`insufficientData` посчитаны backend, клиент их не трогает.
extension PlantHealthResponseMapper on PlantHealthResponse {
  PlantHealth toDomain() => PlantHealth(
        // Спека гарантирует 0..100, но сгенерированный клиент границы не
        // валидирует — клампим, чтобы число в кольце/бейдже не уехало, если
        // backend отдаст значение вне диапазона.
        score: score.clamp(0, 100),
        zone: zone._toDomain(),
        insufficientData: insufficientData,
      );
}

/// Сгенерированный enum (включая `$unknown` от swagger_parser) → доменная
/// [HealthZone]. `$unknown` (новая зона на backend) деградирует мягко в
/// `green` через [HealthZone.fromApi] — экран не падает.
extension on PlantHealthResponseZone {
  HealthZone _toDomain() => switch (this) {
        PlantHealthResponseZone.green => HealthZone.green,
        PlantHealthResponseZone.yellow => HealthZone.yellow,
        PlantHealthResponseZone.red => HealthZone.red,
        PlantHealthResponseZone.$unknown => HealthZone.green,
      };
}
