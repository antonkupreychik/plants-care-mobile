// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeUpdateRequest _$MeUpdateRequestFromJson(Map<String, dynamic> json) =>
    MeUpdateRequest(
      quietHoursStart: json['quietHoursStart'] as String?,
      quietHoursEnd: json['quietHoursEnd'] as String?,
      timezone: json['timezone'] as String?,
      locale: json['locale'] as String?,
      seasonalEnabled: json['seasonalEnabled'] as bool?,
      seasonalMode: json['seasonalMode'] as String?,
      weatherEnabled: json['weatherEnabled'] as bool?,
    );

Map<String, dynamic> _$MeUpdateRequestToJson(MeUpdateRequest instance) =>
    <String, dynamic>{
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'timezone': instance.timezone,
      'locale': instance.locale,
      'seasonalEnabled': instance.seasonalEnabled,
      'seasonalMode': instance.seasonalMode,
      'weatherEnabled': instance.weatherEnabled,
    };
