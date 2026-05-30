// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_schedule_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareScheduleUpdateRequest _$CareScheduleUpdateRequestFromJson(
  Map<String, dynamic> json,
) => CareScheduleUpdateRequest(
  every: (json['every'] as num).toInt(),
  unit: json['unit'] as String,
  enabled: json['enabled'] as bool,
  amountMl: (json['amountMl'] as num?)?.toInt(),
);

Map<String, dynamic> _$CareScheduleUpdateRequestToJson(
  CareScheduleUpdateRequest instance,
) => <String, dynamic>{
  'every': instance.every,
  'unit': instance.unit,
  'amountMl': instance.amountMl,
  'enabled': instance.enabled,
};
