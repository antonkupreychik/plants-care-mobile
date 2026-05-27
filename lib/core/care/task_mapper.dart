import '../api/generated/models/task_dto.dart';
import 'care_task.dart';
import 'care_task_type.dart';

/// Маппинг [TaskDto] (`/today`, `/calendar`) → domain [CareTask] (MADR-002).
///
/// Точка нормализации «грязного» контракта: строковый `taskType`
/// (`WATERING`/...) превращается в domain-enum [CareTaskType] (BACKEND-GAPS G7).
/// Покрывается unit-тестом (test-writer).
extension TaskDtoMapper on TaskDto {
  CareTask toDomain() => CareTask(
        scheduleId: scheduleId,
        plantId: plantId,
        plantName: plantName,
        type: CareTaskType.fromApi(taskType),
        dueAt: nextDueAt,
        locationName: locationName,
      );
}
