import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_dto.dart';
import 'package:plantcare_mobile/core/locations/location_mapper.dart';

void main() {
  group('LocationDtoMapper.toDomain', () {
    test('should_carry_all_fields_and_rename_defaultLocation_to_isDefault', () {
      final created = DateTime.utc(2026, 3, 4);
      final dto = LocationDto(
        id: 8,
        name: 'Спальня',
        defaultLocation: true,
        emoji: '🛏️',
        createdAt: created,
      );

      final loc = dto.toDomain();

      expect(loc.id, 8);
      expect(loc.name, 'Спальня');
      expect(loc.isDefault, isTrue);
      expect(loc.emoji, '🛏️');
      expect(loc.createdAt, created);
    });

    test('should_keep_optionals_null_and_isDefault_false_when_minimal', () {
      const dto = LocationDto(id: 1, name: 'Балкон', defaultLocation: false);

      final loc = dto.toDomain();

      expect(loc.id, 1);
      expect(loc.name, 'Балкон');
      expect(loc.isDefault, isFalse);
      expect(loc.emoji, isNull);
      expect(loc.createdAt, isNull);
    });
  });
}
