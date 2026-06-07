// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleInput _$ScheduleInputFromJson(Map<String, dynamic> json) =>
    ScheduleInput(
      type: ScheduleInputType.fromJson(json['type'] as String),
      every: (json['every'] as num).toInt(),
      unit: ScheduleInputUnit.fromJson(json['unit'] as String),
      amountMl: (json['amountMl'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScheduleInputToJson(ScheduleInput instance) =>
    <String, dynamic>{
      'type': instance.type,
      'every': instance.every,
      'unit': instance.unit,
      'amountMl': instance.amountMl,
    };
