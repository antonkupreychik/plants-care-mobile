import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_health_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_health_response_zone.dart';
import 'package:plantcare_mobile/features/plant_card/data/mappers/plant_health_mapper.dart';
import 'package:plantcare_mobile/features/plant_card/domain/health_zone.dart';

void main() {
  group('PlantHealthResponseMapper.toDomain', () {
    test('should_map_green_zone_and_score_when_reliable', () {
      const dto = PlantHealthResponse(
        insufficientData: false,
        score: 92,
        zone: PlantHealthResponseZone.green,
      );

      final health = dto.toDomain();

      expect(health.score, 92);
      expect(health.zone, HealthZone.green);
      expect(health.insufficientData, isFalse);
      expect(health.hasReliableScore, isTrue);
    });

    test('should_map_yellow_zone', () {
      const dto = PlantHealthResponse(
        insufficientData: false,
        score: 55,
        zone: PlantHealthResponseZone.yellow,
      );

      final health = dto.toDomain();

      expect(health.zone, HealthZone.yellow);
      expect(health.score, 55);
    });

    test('should_map_red_zone', () {
      const dto = PlantHealthResponse(
        insufficientData: false,
        score: 12,
        zone: PlantHealthResponseZone.red,
      );

      final health = dto.toDomain();

      expect(health.zone, HealthZone.red);
      expect(health.score, 12);
    });

    test('should_degrade_unknown_zone_to_green_without_throwing', () {
      const dto = PlantHealthResponse(
        insufficientData: false,
        score: 40,
        zone: PlantHealthResponseZone.$unknown,
      );

      final health = dto.toDomain();

      expect(health.zone, HealthZone.green);
    });

    test('should_set_hasReliableScore_false_when_insufficientData_true', () {
      const dto = PlantHealthResponse(
        insufficientData: true,
        score: 0,
        zone: PlantHealthResponseZone.green,
      );

      final health = dto.toDomain();

      expect(health.insufficientData, isTrue);
      expect(health.hasReliableScore, isFalse);
    });

    test('should_set_hasReliableScore_true_when_insufficientData_false', () {
      const dto = PlantHealthResponse(
        insufficientData: false,
        score: 70,
        zone: PlantHealthResponseZone.green,
      );

      final health = dto.toDomain();

      expect(health.hasReliableScore, isTrue);
    });
  });

  group('HealthZone.fromApi', () {
    test('should_map_GREEN_to_green', () {
      expect(HealthZone.fromApi('GREEN'), HealthZone.green);
    });

    test('should_map_YELLOW_to_yellow', () {
      expect(HealthZone.fromApi('YELLOW'), HealthZone.yellow);
    });

    test('should_map_RED_to_red', () {
      expect(HealthZone.fromApi('RED'), HealthZone.red);
    });

    test('should_degrade_unknown_value_to_green_without_throwing', () {
      expect(HealthZone.fromApi('PURPLE'), HealthZone.green);
    });

    test('should_degrade_empty_value_to_green', () {
      expect(HealthZone.fromApi(''), HealthZone.green);
    });
  });
}
