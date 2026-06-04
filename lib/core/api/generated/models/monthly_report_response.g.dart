// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyReportResponse _$MonthlyReportResponseFromJson(
  Map<String, dynamic> json,
) => MonthlyReportResponse(
  month: json['month'] as String,
  done: (json['done'] as num).toInt(),
  overdue: (json['overdue'] as num).toInt(),
  byType: Map<String, int>.from(json['byType'] as Map),
  streak: (json['streak'] as num).toInt(),
  healthTrend: (json['healthTrend'] as List<dynamic>)
      .map((e) => WeeklyHealthBucket.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MonthlyReportResponseToJson(
  MonthlyReportResponse instance,
) => <String, dynamic>{
  'month': instance.month,
  'done': instance.done,
  'overdue': instance.overdue,
  'byType': instance.byType,
  'streak': instance.streak,
  'healthTrend': instance.healthTrend,
};
