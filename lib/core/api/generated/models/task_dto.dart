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
  });
  
  factory TaskDto.fromJson(Map<String, Object?> json) => _$TaskDtoFromJson(json);
  
  final int scheduleId;
  final int plantId;
  final String plantName;

  /// Вид растения (`Species.id`). Для выбора иллюстрации (mobile gap G6).
  final int? speciesId;

  /// Имя вида (для иллюстрации/подписи).
  final String? speciesName;

  /// Имя `TaskType.name()` — `WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`.
  final String taskType;
  final String? locationName;

  /// Ближайший дедлайн (UTC).
  final DateTime nextDueAt;

  Map<String, Object?> toJson() => _$TaskDtoToJson(this);
}
