import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_species_summary_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_detail_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_summary_dto.dart';
import 'package:plantcare_mobile/features/catalog/data/mappers/species_mapper.dart';
import 'package:plantcare_mobile/features/catalog/domain/care_difficulty.dart';
import 'package:plantcare_mobile/features/catalog/domain/light_preference.dart';

void main() {
  group('SpeciesSummaryDtoMapper.toDomain', () {
    test('should_carry_all_fields_when_full_dto', () {
      const dto = SpeciesSummaryDto(
        id: 7,
        name: 'Монстера',
        latinName: 'Monstera deliciosa',
        wateringDays: 7,
        mistingDays: 3,
        fertilizingDays: 30,
        soilCheckDays: 5,
        careDifficulty: 'EASY',
        lightPreference: 'BRIGHT_INDIRECT',
      );

      final species = dto.toDomain();

      expect(species.id, 7);
      expect(species.name, 'Монстера');
      expect(species.latinName, 'Monstera deliciosa');
      expect(species.wateringDays, 7);
      expect(species.mistingDays, 3);
      expect(species.fertilizingDays, 30);
      expect(species.soilCheckDays, 5);
      expect(species.careDifficulty, CareDifficulty.easy);
      expect(species.lightPreference, LightPreference.brightIndirect);
    });

    test('should_keep_nullable_intervals_null_when_absent', () {
      const dto = SpeciesSummaryDto(id: 1, name: 'Bare');

      final species = dto.toDomain();

      expect(species.id, 1);
      expect(species.name, 'Bare');
      expect(species.latinName, isNull);
      expect(species.wateringDays, isNull);
      expect(species.mistingDays, isNull);
      expect(species.fertilizingDays, isNull);
      expect(species.soilCheckDays, isNull);
      // null enum-коды → unknown (не падаем).
      expect(species.careDifficulty, CareDifficulty.unknown);
      expect(species.lightPreference, LightPreference.unknown);
    });
  });

  group('SpeciesDetailDtoMapper.toDomain', () {
    test('should_carry_all_fields_including_description_when_full_dto', () {
      const dto = SpeciesDetailDto(
        id: 9,
        name: 'Фикус',
        latinName: 'Ficus elastica',
        wateringDays: 10,
        mistingDays: 4,
        fertilizingDays: 28,
        soilCheckDays: 6,
        careDifficulty: 'MEDIUM',
        lightPreference: 'PARTIAL_SHADE',
        description: 'Неприхотливое растение с глянцевыми листьями.',
      );

      final detail = dto.toDomain();

      expect(detail.id, 9);
      expect(detail.name, 'Фикус');
      expect(detail.latinName, 'Ficus elastica');
      expect(detail.wateringDays, 10);
      expect(detail.mistingDays, 4);
      expect(detail.fertilizingDays, 28);
      expect(detail.soilCheckDays, 6);
      expect(detail.careDifficulty, CareDifficulty.medium);
      expect(detail.lightPreference, LightPreference.partialShade);
      expect(detail.description, 'Неприхотливое растение с глянцевыми листьями.');
    });

    test('should_keep_description_and_intervals_null_when_minimal_dto', () {
      const dto = SpeciesDetailDto(id: 2, name: 'Bare');

      final detail = dto.toDomain();

      expect(detail.id, 2);
      expect(detail.name, 'Bare');
      expect(detail.description, isNull);
      expect(detail.wateringDays, isNull);
      expect(detail.mistingDays, isNull);
      expect(detail.fertilizingDays, isNull);
      expect(detail.soilCheckDays, isNull);
      expect(detail.careDifficulty, CareDifficulty.unknown);
      expect(detail.lightPreference, LightPreference.unknown);
    });
  });

  group('PageResponseSpeciesSummaryDtoMapper.toDomain', () {
    test('should_map_items_and_pagination_fields', () {
      const dto = PageResponseSpeciesSummaryDto(
        items: [
          SpeciesSummaryDto(id: 1, name: 'A'),
          SpeciesSummaryDto(id: 2, name: 'B'),
        ],
        total: 42,
        offset: 20,
        limit: 20,
      );

      final page = dto.toDomain();

      expect(page.items.map((s) => s.id), [1, 2]);
      expect(page.total, 42);
      expect(page.offset, 20);
      expect(page.limit, 20);
    });

    test('should_map_empty_items', () {
      const dto = PageResponseSpeciesSummaryDto(
        items: [],
        total: 0,
        offset: 0,
        limit: 20,
      );

      final page = dto.toDomain();

      expect(page.items, isEmpty);
      expect(page.total, 0);
    });
  });

  // Маппинг enum'ов — точка нормализации контракта. Покрываем КАЖДУЮ ветку
  // обоих switch'ей, включая фактические коды dev-backend (BRIGHT/PARTIAL/SHADE),
  // которые раньше падали в unknown (регрессия).
  group('careDifficulty enum mapping', () {
    SpeciesSummaryDto dtoWith(String? raw) =>
        SpeciesSummaryDto(id: 1, name: 'x', careDifficulty: raw);

    test('should_map_EASY', () {
      expect(dtoWith('EASY').toDomain().careDifficulty, CareDifficulty.easy);
    });

    test('should_map_MEDIUM', () {
      expect(
          dtoWith('MEDIUM').toDomain().careDifficulty, CareDifficulty.medium);
    });

    test('should_map_HARD', () {
      expect(dtoWith('HARD').toDomain().careDifficulty, CareDifficulty.hard);
    });

    test('should_map_lowercase_to_correct_difficulty', () {
      expect(dtoWith('easy').toDomain().careDifficulty, CareDifficulty.easy);
    });

    test('should_map_null_to_unknown', () {
      expect(dtoWith(null).toDomain().careDifficulty, CareDifficulty.unknown);
    });

    test('should_map_garbage_to_unknown', () {
      expect(dtoWith('FOOBAR').toDomain().careDifficulty,
          CareDifficulty.unknown);
    });

    test('should_map_empty_string_to_unknown', () {
      expect(dtoWith('').toDomain().careDifficulty, CareDifficulty.unknown);
    });
  });

  group('lightPreference enum mapping', () {
    SpeciesSummaryDto dtoWith(String? raw) =>
        SpeciesSummaryDto(id: 1, name: 'x', lightPreference: raw);

    test('should_map_FULL_SUN', () {
      expect(dtoWith('FULL_SUN').toDomain().lightPreference,
          LightPreference.fullSun);
    });

    // Регрессия: dev-backend отдаёт короткий код BRIGHT — раньше → unknown.
    test('should_map_BRIGHT_short_code_to_brightIndirect', () {
      expect(dtoWith('BRIGHT').toDomain().lightPreference,
          LightPreference.brightIndirect);
    });

    test('should_map_documented_BRIGHT_INDIRECT_to_brightIndirect', () {
      expect(dtoWith('BRIGHT_INDIRECT').toDomain().lightPreference,
          LightPreference.brightIndirect);
    });

    // Регрессия: dev-backend отдаёт короткий код PARTIAL — раньше → unknown.
    test('should_map_PARTIAL_short_code_to_partialShade', () {
      expect(dtoWith('PARTIAL').toDomain().lightPreference,
          LightPreference.partialShade);
    });

    test('should_map_documented_PARTIAL_SHADE_to_partialShade', () {
      expect(dtoWith('PARTIAL_SHADE').toDomain().lightPreference,
          LightPreference.partialShade);
    });

    test('should_map_SHADE', () {
      expect(
          dtoWith('SHADE').toDomain().lightPreference, LightPreference.shade);
    });

    test('should_map_lowercase_to_correct_light', () {
      expect(dtoWith('bright').toDomain().lightPreference,
          LightPreference.brightIndirect);
    });

    test('should_map_null_to_unknown', () {
      expect(
          dtoWith(null).toDomain().lightPreference, LightPreference.unknown);
    });

    test('should_map_garbage_to_unknown', () {
      expect(dtoWith('DIM_GLOW').toDomain().lightPreference,
          LightPreference.unknown);
    });

    test('should_map_empty_string_to_unknown', () {
      expect(dtoWith('').toDomain().lightPreference, LightPreference.unknown);
    });
  });
}
