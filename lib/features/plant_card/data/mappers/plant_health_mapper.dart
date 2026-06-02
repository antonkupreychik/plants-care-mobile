import '../../../../core/api/generated/models/plant_health_dto.dart';
import '../../../../core/api/generated/models/plant_health_dto_zone.dart';
import '../../domain/health_zone.dart';
import '../../domain/plant_health.dart';

/// Маппинг [PlantHealthDto] (`/plants/{id}/health`) → domain [PlantHealth]
/// (MADR-002/007). Делаем руками — сгенерированный код не правим.
///
/// `score`/`zone`/`insufficientData` посчитаны backend, клиент их не трогает.
extension PlantHealthDtoMapper on PlantHealthDto {
  PlantHealth toDomain() => PlantHealth(
        insufficientData: insufficientData,
        // При insufficientData backend отдаёт score/zone = null — пробрасываем
        // как null (UI рисует нейтральное «—»). Клампим 0..100 на случай, если
        // backend отдаст значение вне диапазона (генерированный клиент границы
        // не валидирует).
        score: score?.clamp(0, 100),
        zone: zone?._toDomain(),
      );
}

/// Сгенерированный enum (включая `$unknown` от swagger_parser) → доменная
/// [HealthZone]. `$unknown` (новая зона на backend) деградирует мягко в
/// `green` через [HealthZone.fromApi] — экран не падает.
extension on PlantHealthDtoZone {
  HealthZone _toDomain() => switch (this) {
        PlantHealthDtoZone.green => HealthZone.green,
        PlantHealthDtoZone.yellow => HealthZone.yellow,
        PlantHealthDtoZone.red => HealthZone.red,
        PlantHealthDtoZone.$unknown => HealthZone.green,
      };
}
