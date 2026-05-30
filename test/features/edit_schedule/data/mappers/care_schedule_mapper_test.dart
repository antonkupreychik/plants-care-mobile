import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_schedule_dto.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/mappers/care_schedule_mapper.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/care_schedule_unit.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';

void main() {
  group('CareScheduleDto.toDomain', () {
    test('should_map_all_fields_and_normalize_type_unit_when_known', () {
      final dto = CareScheduleDto(
        type: 'WATERING',
        every: 7,
        unit: 'DAY',
        enabled: true,
        amountMl: 200,
        nextDueAt: DateTime.utc(2026, 6, 1, 9),
      );

      final domain = dto.toDomain();

      expect(domain.type, CareTaskType.watering);
      expect(domain.rawType, 'WATERING');
      expect(domain.every, 7);
      expect(domain.unit, CareScheduleUnit.day);
      expect(domain.rawUnit, 'DAY');
      expect(domain.amountMl, 200);
      expect(domain.enabled, isTrue);
      expect(domain.nextDueAt, DateTime.utc(2026, 6, 1, 9));
    });

    test('should_map_unknown_type_to_unknown_but_keep_rawType', () {
      const dto = CareScheduleDto(
        type: 'PRUNING', // нет в enum
        every: 3,
        unit: 'DAY',
        enabled: true,
      );

      final domain = dto.toDomain();

      // Нераспознанный тип → unknown, но исходная строка сохранена для PUT.
      expect(domain.type, CareTaskType.unknown);
      expect(domain.rawType, 'PRUNING');
    });

    test('should_map_unknown_unit_to_unknown_but_keep_rawUnit_for_roundtrip', () {
      const dto = CareScheduleDto(
        type: 'MISTING',
        every: 2,
        unit: 'WEEK', // нет в enum CareScheduleUnit
        enabled: true,
      );

      final domain = dto.toDomain();

      expect(domain.unit, CareScheduleUnit.unknown);
      // rawUnit держит исходную строку, чтобы PUT не потерял единицу.
      expect(domain.rawUnit, 'WEEK');
    });

    test('should_clamp_every_to_at_least_1_when_dto_below_1', () {
      const dtoZero = CareScheduleDto(
        type: 'FERTILIZING',
        every: 0,
        unit: 'DAY',
        enabled: true,
      );
      const dtoNegative = CareScheduleDto(
        type: 'FERTILIZING',
        every: -5,
        unit: 'DAY',
        enabled: true,
      );

      expect(dtoZero.toDomain().every, 1);
      expect(dtoNegative.toDomain().every, 1);
    });

    test('should_keep_null_nextDueAt_and_null_amountMl', () {
      const dto = CareScheduleDto(
        type: 'SOIL_CHECK',
        every: 14,
        unit: 'DAY',
        enabled: false,
        // amountMl и nextDueAt не заданы.
      );

      final domain = dto.toDomain();

      expect(domain.amountMl, isNull);
      expect(domain.nextDueAt, isNull);
      expect(domain.enabled, isFalse);
    });
  });

  group('PlantCareSchedule.toUpdateRequest', () {
    test('should_map_editable_fields_and_send_rawUnit_as_unit', () {
      const schedule = PlantCareSchedule(
        type: CareTaskType.watering,
        rawType: 'WATERING',
        every: 5,
        unit: CareScheduleUnit.day,
        rawUnit: 'DAY',
        amountMl: 250,
        enabled: true,
      );

      final req = schedule.toUpdateRequest();

      expect(req.every, 5);
      // unit отправляется как исходная backend-строка (rawUnit), не enum.
      expect(req.unit, 'DAY');
      expect(req.amountMl, 250);
      expect(req.enabled, isTrue);
    });

    test('should_send_original_rawUnit_even_when_unit_is_unknown', () {
      // Round-trip нераспознанной единицы: enum unknown, но rawUnit не теряется.
      const schedule = PlantCareSchedule(
        type: CareTaskType.misting,
        rawType: 'MISTING',
        every: 2,
        unit: CareScheduleUnit.unknown,
        rawUnit: 'WEEK',
        enabled: true,
      );

      final req = schedule.toUpdateRequest();

      expect(req.unit, 'WEEK');
    });

    test('should_keep_null_amountMl_when_not_set', () {
      const schedule = PlantCareSchedule(
        type: CareTaskType.fertilizing,
        rawType: 'FERTILIZING',
        every: 30,
        unit: CareScheduleUnit.day,
        rawUnit: 'DAY',
        enabled: false,
      );

      final req = schedule.toUpdateRequest();

      expect(req.amountMl, isNull);
      expect(req.enabled, isFalse);
    });
  });
}
