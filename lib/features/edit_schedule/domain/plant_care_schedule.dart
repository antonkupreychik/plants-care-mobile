import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task_type.dart';
import 'care_schedule_unit.dart';

part 'plant_care_schedule.freezed.dart';

/// Доменная модель «Расписание ухода одного типа» для растения (экран 22).
///
/// Источник — `GET /plants/{id}/schedules` (`CareScheduleDto`). Интервалы и
/// [nextDueAt] посчитаны backend; клиент их НЕ пересчитывает (FLUTTER.md
/// «Время»).
///
/// [type] — общий доменный [CareTaskType] (тот же enum, что у `/today`,
/// `/calendar`, отчёта). [unit] нормализована в [CareScheduleUnit]. Маппинг
/// строк делает маппер data-слоя (MADR-002).
///
/// [rawUnit] хранит исходную backend-строку единицы (`DAY`), чтобы при
/// сохранении (`PUT`) отправить её обратно как есть — даже если значение
/// нераспознанное ([CareScheduleUnit.unknown]). Так редактирование `every`/
/// `enabled` неизвестной единицы не теряет её (last-write-wins безопасно).
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class PlantCareSchedule with _$PlantCareSchedule {
  const factory PlantCareSchedule({
    /// Тип ухода (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`).
    required CareTaskType type,

    /// Исходная backend-строка типа (`WATERING`…) для path-параметра `PUT`
    /// и round-trip нераспознанного типа ([CareTaskType.unknown]) без потери.
    required String rawType,

    /// Интервал повторения в единицах [unit]. Всегда `>= 1`.
    required int every,

    /// Единица интервала (нормализована из [rawUnit]).
    required CareScheduleUnit unit,

    /// Исходная backend-строка единицы (`DAY`) для round-trip при `PUT`.
    required String rawUnit,

    /// Объём воды в мл (для полива). `null` — не задан / не применим.
    int? amountMl,

    /// Активно ли расписание (генерирует задачи).
    required bool enabled,

    /// Момент следующей задачи (UTC), посчитан backend. `null` — неактивно /
    /// срок не определён.
    DateTime? nextDueAt,
  }) = _PlantCareSchedule;

  const PlantCareSchedule._();

  /// Поля, которые влияют на «грязность» при редактировании драфта: тип
  /// расписания тот же, сравниваем редактируемые значения. [nextDueAt] считает
  /// backend — клиент его не редактирует и в сравнение dirty не включает (он
  /// меняется только после сохранения, по ответу сервера).
  bool sameEditableFields(PlantCareSchedule other) =>
      type == other.type &&
      rawType == other.rawType &&
      every == other.every &&
      unit == other.unit &&
      rawUnit == other.rawUnit &&
      amountMl == other.amountMl &&
      enabled == other.enabled;
}
