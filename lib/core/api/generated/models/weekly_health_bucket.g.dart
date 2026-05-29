// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_health_bucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyHealthBucket _$WeeklyHealthBucketFromJson(Map<String, dynamic> json) =>
    WeeklyHealthBucket(
      week: json['week'] as String,
      done: (json['done'] as num).toInt(),
      onTimePct: (json['onTimePct'] as num).toDouble(),
    );

Map<String, dynamic> _$WeeklyHealthBucketToJson(WeeklyHealthBucket instance) =>
    <String, dynamic>{
      'week': instance.week,
      'done': instance.done,
      'onTimePct': instance.onTimePct,
    };
