// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

/// Задача ухода в выдаче `today`/`calendar`.
@JsonSerializable()
class TaskDto {
  const TaskDto({
    required this.scheduleId,
    required this.plantId,
    required this.plantName,
    required this.taskType,
    required this.nextDueAt,
    this.speciesId,
    this.speciesName,
    this.locationName,
    this.doneAt,
  });
  
  factory TaskDto.fromJson(Map<String, Object?> json) => _$TaskDtoFromJson(json);
  
  final int scheduleId;
  final int plantId;
  final String plantName;

  /// Id вида растения (`Species.id`), если вид задан. Нужен клиенту, чтобы.
  /// выбрать иллюстрацию задачи (mobile gap G6). `null`, если у растения.
  /// нет привязки к виду.
  ///
  final int? speciesId;

  /// Денормализованное имя вида (подпись/фолбэк иллюстрации). `null`, если вид не задан.
  final String? speciesName;

  /// Имя `TaskType.name()` — `WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`.
  final String taskType;
  final String? locationName;

  /// Ближайший дедлайн (UTC).
  final DateTime nextDueAt;

  /// Момент отметки «сделано» (UTC), если задача выполнена сегодня.
  /// (mobile gap G11, ADR-014). `null` — задача ещё не выполнена (pending).
  /// В выдаче `/calendar` всегда `null`.
  ///
  final DateTime? doneAt;

  Map<String, Object?> toJson() => _$TaskDtoToJson(this);
}
