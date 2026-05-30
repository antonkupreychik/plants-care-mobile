// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareScheduleDto _$CareScheduleDtoFromJson(Map<String, dynamic> json) =>
    CareScheduleDto(
      type: json['type'] as String,
      every: (json['every'] as num).toInt(),
      unit: json['unit'] as String,
      enabled: json['enabled'] as bool,
      amountMl: (json['amountMl'] as num?)?.toInt(),
      nextDueAt: json['nextDueAt'] == null
          ? null
          : DateTime.parse(json['nextDueAt'] as String),
    );

Map<String, dynamic> _$CareScheduleDtoToJson(CareScheduleDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'every': instance.every,
      'unit': instance.unit,
      'amountMl': instance.amountMl,
      'enabled': instance.enabled,
      'nextDueAt': instance.nextDueAt?.toIso8601String(),
    };
