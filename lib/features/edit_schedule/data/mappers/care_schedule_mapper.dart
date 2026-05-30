import '../../../../core/api/generated/models/care_schedule_dto.dart';
import '../../../../core/api/generated/models/care_schedule_update_request.dart';
import '../../../../core/care/care_task_type.dart';
import '../../domain/care_schedule_unit.dart';
import '../../domain/plant_care_schedule.dart';

/// Маппинг `CareScheduleDto` ↔ domain [PlantCareSchedule] (MADR-002/007).
/// Делаем руками — сгенерированный код не правим.
///
/// Точки нормализации:
/// - строка `type` (`WATERING`/…) → [CareTaskType] (`fromApi`), исходная строка
///   сохраняется в [PlantCareSchedule.rawType] для round-trip;
/// - строка `unit` (`DAY`) → [CareScheduleUnit] (`fromApi`), исходная строка —
///   в [PlantCareSchedule.rawUnit];
/// - `every` клампится до `>= 1` на входе (backend не должен слать `< 1`, но
///   модель гарантирует инвариант для UI-степпера).
extension CareScheduleDtoMapper on CareScheduleDto {
  PlantCareSchedule toDomain() => PlantCareSchedule(
        type: CareTaskType.fromApi(type),
        rawType: type,
        every: every < 1 ? 1 : every,
        unit: CareScheduleUnit.fromApi(unit),
        rawUnit: unit,
        amountMl: amountMl,
        enabled: enabled,
        nextDueAt: nextDueAt,
      );
}

/// Маппинг domain [PlantCareSchedule] → тело `PUT`
/// (`CareScheduleUpdateRequest`).
///
/// `unit` отправляется обратно как исходная backend-строка ([rawUnit]) — даже
/// для нераспознанной единицы значение не теряется. `every` гарантированно
/// `>= 1` (инвариант модели + clamp контроллера).
extension PlantCareScheduleUpdateMapper on PlantCareSchedule {
  CareScheduleUpdateRequest toUpdateRequest() => CareScheduleUpdateRequest(
        every: every,
        unit: rawUnit,
        amountMl: amountMl,
        enabled: enabled,
      );
}
