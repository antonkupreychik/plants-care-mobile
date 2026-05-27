import 'package:flutter_test/flutter_test.dart';
import 'package:plantcate_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcate_mobile/features/home/data/mappers/plant_mapper.dart';

void main() {
  group('PlantDtoMapper.toDomain', () {
    test('should_carry_all_fields_when_full_dto', () {
      final created = DateTime.utc(2026, 1, 2, 3, 4);
      final dto = PlantDto(
        id: 11,
        name: 'Фикус',
        archived: false,
        notes: 'у окна',
        photoFileId: 'file-123',
        locationId: 5,
        locationName: 'Кухня',
        speciesId: 9,
        speciesName: 'Ficus',
        createdAt: created,
      );

      final plant = dto.toDomain();

      expect(plant.id, 11);
      expect(plant.name, 'Фикус');
      expect(plant.notes, 'у окна');
      expect(plant.photoFileId, 'file-123');
      expect(plant.locationId, 5);
      expect(plant.locationName, 'Кухня');
      expect(plant.speciesId, 9);
      expect(plant.speciesName, 'Ficus');
      expect(plant.createdAt, created);
    });

    test('should_keep_optionals_null_when_minimal_dto', () {
      const dto = PlantDto(id: 1, name: 'Bare', archived: false);

      final plant = dto.toDomain();

      expect(plant.id, 1);
      expect(plant.name, 'Bare');
      expect(plant.notes, isNull);
      expect(plant.photoFileId, isNull);
      expect(plant.locationId, isNull);
      expect(plant.locationName, isNull);
      expect(plant.speciesId, isNull);
      expect(plant.speciesName, isNull);
      expect(plant.createdAt, isNull);
    });

    // `archived` намеренно не существует в domain Plant — маппинг не должен
    // зависеть от него (список /plants отдаёт только активные).
    test('should_map_even_when_dto_archived_true', () {
      const dto = PlantDto(id: 2, name: 'Old', archived: true);

      final plant = dto.toDomain();

      expect(plant.id, 2);
      expect(plant.name, 'Old');
    });
  });
}
