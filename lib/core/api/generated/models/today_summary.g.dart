// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodaySummary _$TodaySummaryFromJson(Map<String, dynamic> json) => TodaySummary(
  total: (json['total'] as num).toInt(),
  done: (json['done'] as num).toInt(),
  remaining: (json['remaining'] as num).toInt(),
  overdue: (json['overdue'] as num).toInt(),
);

Map<String, dynamic> _$TodaySummaryToJson(TodaySummary instance) =>
    <String, dynamic>{
      'total': instance.total,
      'done': instance.done,
      'remaining': instance.remaining,
      'overdue': instance.overdue,
    };
