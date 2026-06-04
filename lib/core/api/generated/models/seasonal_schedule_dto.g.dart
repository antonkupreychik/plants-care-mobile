// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonalScheduleDto _$SeasonalScheduleDtoFromJson(Map<String, dynamic> json) =>
    SeasonalScheduleDto(
      active: json['active'] as bool,
      summerIntervalDays: (json['summerIntervalDays'] as num).toInt(),
      winterIntervalDays: (json['winterIntervalDays'] as num).toInt(),
    );

Map<String, dynamic> _$SeasonalScheduleDtoToJson(
  SeasonalScheduleDto instance,
) => <String, dynamic>{
  'active': instance.active,
  'summerIntervalDays': instance.summerIntervalDays,
  'winterIntervalDays': instance.winterIntervalDays,
};
