import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/vacation_response.dart';
import 'package:plantcare_mobile/features/vacation/data/mappers/vacation_mapper.dart';

void main() {
  group('VacationResponseMapper', () {
    test('should_map_active_with_pausedUntil', () {
      final dto = VacationResponse(
        active: true,
        pausedUntil: DateTime.utc(2026, 6, 14, 20, 59, 59),
      );

      final status = dto.toVacationStatus();

      expect(status.active, isTrue);
      expect(status.pausedUntil, DateTime.utc(2026, 6, 14, 20, 59, 59));
    });

    test('should_map_inactive_with_null_pausedUntil', () {
      const dto = VacationResponse(active: false);

      final status = dto.toVacationStatus();

      expect(status.active, isFalse);
      expect(status.pausedUntil, isNull);
    });
  });
}
