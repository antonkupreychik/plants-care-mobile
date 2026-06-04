import '../../../../core/api/generated/models/weather_snapshot_dto.dart';
import '../../../../core/api/generated/models/weather_snapshot_dto_recommendation.dart';
import '../../domain/watering_recommendation.dart';
import '../../domain/weather_snapshot.dart';

/// Маппинг [WeatherSnapshotDto] (`/weather/snapshot`) → domain
/// [WeatherSnapshot] (MADR-002/007). Делаем руками — сгенерированный код не
/// правим.
///
/// `available`/`humidityPercent`/`recommendation` посчитаны backend, клиент их
/// не трогает. При `available=false` все nullable-поля приходят `null` —
/// пробрасываем как есть.
extension WeatherSnapshotDtoMapper on WeatherSnapshotDto {
  WeatherSnapshot toDomain() => WeatherSnapshot(
        available: available,
        // Клампим 0..100 на случай, если backend отдаст значение вне диапазона
        // (генерированный клиент границы не валидирует).
        humidityPercent: humidityPercent?.clamp(0, 100),
        recommendation: recommendation?._toDomain(),
        // Генерированный клиент уже даёт DateTime (format: date-time, UTC).
        fetchedAt: fetchedAt,
        fromCache: fromCache,
      );
}

/// Сгенерированный enum (включая `$unknown` от swagger_parser) → доменная
/// [WateringRecommendation]. `$unknown` (новая рекомендация на backend)
/// деградирует мягко в `neutral` — экран не падает.
extension on WeatherSnapshotDtoRecommendation {
  WateringRecommendation _toDomain() => switch (this) {
        WeatherSnapshotDtoRecommendation.deferOk =>
          WateringRecommendation.deferOk,
        WeatherSnapshotDtoRecommendation.doNotDefer =>
          WateringRecommendation.doNotDefer,
        WeatherSnapshotDtoRecommendation.neutral =>
          WateringRecommendation.neutral,
        WeatherSnapshotDtoRecommendation.$unknown =>
          WateringRecommendation.neutral,
      };
}
