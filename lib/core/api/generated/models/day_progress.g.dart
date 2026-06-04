// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayProgress _$DayProgressFromJson(Map<String, dynamic> json) => DayProgress(
  planned: (json['planned'] as num).toInt(),
  done: (json['done'] as num).toInt(),
);

Map<String, dynamic> _$DayProgressToJson(DayProgress instance) =>
    <String, dynamic>{'planned': instance.planned, 'done': instance.done};
