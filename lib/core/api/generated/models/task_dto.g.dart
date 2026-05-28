// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
  scheduleId: (json['scheduleId'] as num).toInt(),
  plantId: (json['plantId'] as num).toInt(),
  plantName: json['plantName'] as String,
  taskType: json['taskType'] as String,
  nextDueAt: DateTime.parse(json['nextDueAt'] as String),
  speciesId: (json['speciesId'] as num?)?.toInt(),
  speciesName: json['speciesName'] as String?,
  locationName: json['locationName'] as String?,
);

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
  'scheduleId': instance.scheduleId,
  'plantId': instance.plantId,
  'plantName': instance.plantName,
  'speciesId': instance.speciesId,
  'speciesName': instance.speciesName,
  'taskType': instance.taskType,
  'locationName': instance.locationName,
  'nextDueAt': instance.nextDueAt.toIso8601String(),
};
