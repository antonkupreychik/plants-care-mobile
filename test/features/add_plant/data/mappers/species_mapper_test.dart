import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_detail_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_summary_dto.dart';
import 'package:plantcare_mobile/features/add_plant/data/mappers/species_mapper.dart';
import 'package:plantcare_mobile/features/add_plant/domain/care_difficulty.dart';

void main() {
  group('SpeciesSummaryDto.toDomain', () {
    test('should_map_all_fields', () {
      const dto = SpeciesSummaryDto(
        id: 11,
        name: 'Фикус',
        latinName: 'Ficus',
        wateringDays: 7,
        mistingDays: 3,
        fertilizingDays: 30,
        soilCheckDays: 14,
        careDifficulty: 'MEDIUM',
        lightPreference: 'BRIGHT_INDIRECT',
      );

      final domain = dto.toDomain();

      expect(domain.id, 11);
      expect(domain.name, 'Фикус');
      expect(domain.latinName, 'Ficus');
      expect(domain.wateringDays, 7);
      expect(domain.mistingDays, 3);
      expect(domain.fertilizingDays, 30);
      expect(domain.soilCheckDays, 14);
      expect(domain.careDifficulty, CareDifficulty.medium);
      // lightPreference пробрасывается как есть (read-only контент backend).
      expect(domain.lightPreference, 'BRIGHT_INDIRECT');
    });

    test('should_default_careDifficulty_to_unknown_when_null', () {
      const dto = SpeciesSummaryDto(id: 1, name: 'X', careDifficulty: null);

      final domain = dto.toDomain();

      expect(domain.careDifficulty, CareDifficulty.unknown);
    });

    test('should_keep_nullable_lightPreference_and_intervals_as_null', () {
      const dto = SpeciesSummaryDto(id: 1, name: 'X');

      final domain = dto.toDomain();

      expect(domain.lightPreference, isNull);
      expect(domain.wateringDays, isNull);
      expect(domain.mistingDays, isNull);
      expect(domain.fertilizingDays, isNull);
      expect(domain.soilCheckDays, isNull);
      expect(domain.latinName, isNull);
    });
  });

  group('SpeciesDetailDto.toDomain', () {
    test('should_map_summary_fields_and_description', () {
      const dto = SpeciesDetailDto(
        id: 5,
        name: 'Монстера',
        latinName: 'Monstera',
        wateringDays: 5,
        careDifficulty: 'EASY',
        lightPreference: 'SHADE',
        description: 'Тропическое растение',
      );

      final domain = dto.toDomain();

      expect(domain.description, 'Тропическое растение');
      expect(domain.summary.id, 5);
      expect(domain.summary.name, 'Монстера');
      expect(domain.summary.latinName, 'Monstera');
      expect(domain.summary.wateringDays, 5);
      expect(domain.summary.careDifficulty, CareDifficulty.easy);
      expect(domain.summary.lightPreference, 'SHADE');
    });

    test('should_keep_null_description', () {
      const dto = SpeciesDetailDto(id: 5, name: 'X', description: null);

      final domain = dto.toDomain();

      expect(domain.description, isNull);
    });
  });
}
