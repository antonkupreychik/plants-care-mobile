import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/weather_snapshot_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/weather_snapshot_response_recommendation.dart';
import 'package:plantcare_mobile/features/weather/data/mappers/weather_snapshot_mapper.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';

void main() {
  group('WeatherSnapshotResponseMapper.toDomain', () {
    test('should_map_all_fields_when_available_true', () {
      final fetchedAt = DateTime.utc(2026, 5, 28, 9, 30);
      final dto = WeatherSnapshotResponse(
        available: true,
        humidityPercent: 88,
        recommendation: WeatherSnapshotResponseRecommendation.deferOk,
        fetchedAt: fetchedAt,
        fromCache: true,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.available, isTrue);
      expect(snapshot.humidityPercent, 88);
      expect(snapshot.recommendation, WateringRecommendation.deferOk);
      expect(snapshot.fetchedAt, fetchedAt);
      expect(snapshot.fromCache, isTrue);
      expect(snapshot.hasData, isTrue);
    });

    // КЛЮЧЕВОЕ: погода не настроена/источник недоступен — available=false и
    // все остальные поля null. Десериализация и маппинг не должны падать,
    // hasData=false → UI не рисует строку (урок G1 про null-поля).
    test('should_map_nulls_and_hasData_false_when_available_false', () {
      const dto = WeatherSnapshotResponse(
        available: false,
        humidityPercent: null,
        recommendation: null,
        fetchedAt: null,
        fromCache: null,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.available, isFalse);
      expect(snapshot.humidityPercent, isNull);
      expect(snapshot.recommendation, isNull);
      expect(snapshot.fetchedAt, isNull);
      expect(snapshot.fromCache, isNull);
      expect(snapshot.hasData, isFalse);
    });

    test('should_map_doNotDefer_recommendation', () {
      const dto = WeatherSnapshotResponse(
        available: true,
        humidityPercent: 20,
        recommendation: WeatherSnapshotResponseRecommendation.doNotDefer,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.recommendation, WateringRecommendation.doNotDefer);
    });

    test('should_map_neutral_recommendation', () {
      const dto = WeatherSnapshotResponse(
        available: true,
        humidityPercent: 50,
        recommendation: WeatherSnapshotResponseRecommendation.neutral,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.recommendation, WateringRecommendation.neutral);
    });

    test('should_degrade_unknown_recommendation_to_neutral_without_throwing',
        () {
      const dto = WeatherSnapshotResponse(
        available: true,
        humidityPercent: 50,
        recommendation: WeatherSnapshotResponseRecommendation.$unknown,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.recommendation, WateringRecommendation.neutral);
    });

    // Маппер клампит влажность в [0,100] — генерированный клиент границы не
    // валидирует, так что защита от мусора с backend проверяется честно.
    test('should_clamp_humidity_above_100', () {
      const dto = WeatherSnapshotResponse(
        available: true,
        humidityPercent: 150,
        recommendation: WeatherSnapshotResponseRecommendation.neutral,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.humidityPercent, 100);
    });

    test('should_clamp_humidity_below_0', () {
      const dto = WeatherSnapshotResponse(
        available: true,
        humidityPercent: -5,
        recommendation: WeatherSnapshotResponseRecommendation.neutral,
      );

      final snapshot = dto.toDomain();

      expect(snapshot.humidityPercent, 0);
    });
  });

  group('WateringRecommendation.fromApi', () {
    test('should_map_DEFER_OK_to_deferOk', () {
      expect(
        WateringRecommendation.fromApi('DEFER_OK'),
        WateringRecommendation.deferOk,
      );
    });

    test('should_map_DO_NOT_DEFER_to_doNotDefer', () {
      expect(
        WateringRecommendation.fromApi('DO_NOT_DEFER'),
        WateringRecommendation.doNotDefer,
      );
    });

    test('should_map_NEUTRAL_to_neutral', () {
      expect(
        WateringRecommendation.fromApi('NEUTRAL'),
        WateringRecommendation.neutral,
      );
    });

    test('should_degrade_unknown_value_to_neutral_without_throwing', () {
      expect(
        WateringRecommendation.fromApi('RAINING_CATS'),
        WateringRecommendation.neutral,
      );
    });

    test('should_degrade_empty_value_to_neutral', () {
      expect(
        WateringRecommendation.fromApi(''),
        WateringRecommendation.neutral,
      );
    });
  });
}
