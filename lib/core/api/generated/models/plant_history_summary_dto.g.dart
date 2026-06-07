// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_history_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantHistorySummaryDto _$PlantHistorySummaryDtoFromJson(
  Map<String, dynamic> json,
) => PlantHistorySummaryDto(
  total: (json['total'] as num).toInt(),
  onTimeCount: (json['onTimeCount'] as num).toInt(),
  onTimePercent: (json['onTimePercent'] as num).toInt(),
  byType: Map<String, int>.from(json['byType'] as Map),
);

Map<String, dynamic> _$PlantHistorySummaryDtoToJson(
  PlantHistorySummaryDto instance,
) => <String, dynamic>{
  'total': instance.total,
  'onTimeCount': instance.onTimeCount,
  'onTimePercent': instance.onTimePercent,
  'byType': instance.byType,
};
