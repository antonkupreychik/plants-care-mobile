import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/features/archive/data/archived_plant_mapper.dart';

PlantDto makeDto({
  int id = 1,
  String name = 'Тест',
  String? speciesName,
  DateTime? archivedAt,
  bool? gifted,
  String? note,
  int? totalCareDays,
}) =>
    PlantDto(
      id: id,
      name: name,
      archived: true,
      speciesName: speciesName,
      archivedAt: archivedAt,
      gifted: gifted,
      note: note,
      totalCareDays: totalCareDays,
    );

void main() {
  group('ArchivedPlantMapper.toDomain — base fields', () {
    test('should_map_id_and_name', () {
      final plant = makeDto(id: 42, name: 'Монстера').toDomain();
      expect(plant.id, 42);
      expect(plant.name, 'Монстера');
    });

    test('should_map_speciesName_when_present', () {
      final plant = makeDto(speciesName: 'Монстера Деликатеса').toDomain();
      expect(plant.speciesName, 'Монстера Деликатеса');
    });

    test('should_use_empty_string_for_speciesName_when_null', () {
      final plant = makeDto(speciesName: null).toDomain();
      expect(plant.speciesName, '');
    });

    test('should_map_gifted_true', () {
      final plant = makeDto(gifted: true).toDomain();
      expect(plant.gifted, isTrue);
    });

    test('should_map_gifted_false', () {
      final plant = makeDto(gifted: false).toDomain();
      expect(plant.gifted, isFalse);
    });

    test('should_default_gifted_to_false_when_null', () {
      final plant = makeDto(gifted: null).toDomain();
      expect(plant.gifted, isFalse);
    });

    test('should_map_note_as_cause', () {
      final plant = makeDto(note: 'Перелив').toDomain();
      expect(plant.cause, 'Перелив');
    });

    test('should_use_empty_string_for_cause_when_note_null', () {
      final plant = makeDto(note: null).toDomain();
      expect(plant.cause, '');
    });
  });

  group('ArchivedPlantMapper.toDomain — livedLabel from totalCareDays', () {
    test('should_return_empty_string_when_totalCareDays_null', () {
      final plant = makeDto(totalCareDays: null).toDomain();
      expect(plant.livedLabel, '');
    });

    test('should_return_empty_string_when_totalCareDays_zero', () {
      final plant = makeDto(totalCareDays: 0).toDomain();
      expect(plant.livedLabel, '');
    });

    test('should_format_less_than_30_days_as_1_month', () {
      final plant = makeDto(totalCareDays: 15).toDomain();
      expect(plant.livedLabel, '1 месяц');
    });

    test('should_format_30_days_as_1_month', () {
      final plant = makeDto(totalCareDays: 30).toDomain();
      expect(plant.livedLabel, '1 месяц');
    });

    test('should_format_335_days_as_11_months', () {
      final plant = makeDto(totalCareDays: 335).toDomain();
      expect(plant.livedLabel, '11 месяцев');
    });

    test('should_format_365_days_as_1_year', () {
      final plant = makeDto(totalCareDays: 365).toDomain();
      expect(plant.livedLabel, '1 год');
    });

    test('should_format_395_days_as_1_year_1_month', () {
      // 395 / 365 = 1 год, 395 % 365 = 30 → 1 мес.
      final plant = makeDto(totalCareDays: 395).toDomain();
      expect(plant.livedLabel, '1 год 1 мес.');
    });

    test('should_format_1167_days_as_3_years_2_months', () {
      // 1167 / 365 = 3 года, 1167 % 365 = 72 → 72 / 30 = 2 мес.
      final plant = makeDto(totalCareDays: 1167).toDomain();
      expect(plant.livedLabel, '3 года 2 мес.');
    });

    test('should_format_2_years_no_months', () {
      // 730 / 365 = 2, 730 % 365 = 0 → 0 мес. → только «2 года»
      final plant = makeDto(totalCareDays: 730).toDomain();
      expect(plant.livedLabel, '2 года');
    });

    test('should_format_5_years_correctly_with_let', () {
      // 1825 / 365 = 5 лет
      final plant = makeDto(totalCareDays: 1825).toDomain();
      expect(plant.livedLabel, '5 лет');
    });
  });

  group('ArchivedPlantMapper.toDomain — archivedDateLabel', () {
    test('should_return_empty_string_when_archivedAt_null', () {
      final plant = makeDto(archivedAt: null).toDomain();
      expect(plant.archivedDateLabel, '');
    });

    test('should_format_april_2026', () {
      final plant = makeDto(archivedAt: DateTime.utc(2026, 4, 15)).toDomain();
      expect(plant.archivedDateLabel, 'апрель 2026');
    });

    test('should_format_january', () {
      final plant = makeDto(archivedAt: DateTime.utc(2026, 1, 1)).toDomain();
      expect(plant.archivedDateLabel, 'январь 2026');
    });

    test('should_format_march', () {
      final plant = makeDto(archivedAt: DateTime.utc(2026, 3, 31)).toDomain();
      expect(plant.archivedDateLabel, 'март 2026');
    });

    test('should_format_december_2025', () {
      final plant = makeDto(archivedAt: DateTime.utc(2025, 12, 1)).toDomain();
      expect(plant.archivedDateLabel, 'декабрь 2025');
    });
  });
}
