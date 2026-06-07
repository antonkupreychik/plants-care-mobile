// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_summary_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodaySummaryBlock _$TodaySummaryBlockFromJson(Map<String, dynamic> json) =>
    TodaySummaryBlock(
      type: TodaySummaryBlockType.fromJson(json['type'] as String),
      total: (json['total'] as num).toInt(),
      done: (json['done'] as num).toInt(),
      remaining: (json['remaining'] as num).toInt(),
      overdue: (json['overdue'] as num).toInt(),
    );

Map<String, dynamic> _$TodaySummaryBlockToJson(TodaySummaryBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
      'total': instance.total,
      'done': instance.done,
      'remaining': instance.remaining,
      'overdue': instance.overdue,
    };
