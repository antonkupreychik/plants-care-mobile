import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/streak_response.dart';
import 'package:plantcare_mobile/features/plant_card/data/mappers/streak_mapper.dart';

void main() {
  group('StreakResponseMapper.toDomain', () {
    test('should_map_streak_field_to_count', () {
      const dto = StreakResponse(plantId: 42, streak: 5);

      final streak = dto.toDomain();

      expect(streak.plantId, 42);
      expect(streak.count, 5);
    });

    test('should_map_zero_streak_to_zero_count', () {
      const dto = StreakResponse(plantId: 1, streak: 0);

      final streak = dto.toDomain();

      expect(streak.count, 0);
    });
  });
}
