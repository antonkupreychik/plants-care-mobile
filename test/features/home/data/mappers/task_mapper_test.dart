import 'package:flutter_test/flutter_test.dart';
import 'package:plantcate_mobile/core/api/generated/models/task_dto.dart';
import 'package:plantcate_mobile/features/home/data/mappers/task_mapper.dart';
import 'package:plantcate_mobile/features/home/domain/care_task_type.dart';

void main() {
  group('TaskDtoMapper.toDomain', () {
    test('should_carry_all_fields_when_full_dto', () {
      final due = DateTime.utc(2026, 5, 27, 9);
      final dto = TaskDto(
        scheduleId: 7,
        plantId: 3,
        plantName: 'Monstera',
        taskType: 'WATERING',
        nextDueAt: due,
        locationName: 'Гостиная',
      );

      final task = dto.toDomain();

      expect(task.scheduleId, 7);
      expect(task.plantId, 3);
      expect(task.plantName, 'Monstera');
      expect(task.type, CareTaskType.watering);
      expect(task.dueAt, due);
      expect(task.locationName, 'Гостиная');
    });

    test('should_keep_locationName_null_when_absent', () {
      final dto = TaskDto(
        scheduleId: 1,
        plantId: 1,
        plantName: 'Fern',
        taskType: 'MISTING',
        nextDueAt: DateTime.utc(2026, 5, 27),
      );

      final task = dto.toDomain();

      expect(task.locationName, isNull);
      expect(task.type, CareTaskType.misting);
    });

    // Маппер обязан нормализовать неизвестный backend-код, а не пробросить как есть.
    test('should_normalize_unknown_taskType_to_unknown_enum', () {
      final dto = TaskDto(
        scheduleId: 1,
        plantId: 1,
        plantName: 'Cactus',
        taskType: 'SOMETHING_NEW',
        nextDueAt: DateTime.utc(2026, 5, 27),
      );

      expect(dto.toDomain().type, CareTaskType.unknown);
    });
  });
}
