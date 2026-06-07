// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_settings_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonalSettingsUpdateRequest _$SeasonalSettingsUpdateRequestFromJson(
  Map<String, dynamic> json,
) => SeasonalSettingsUpdateRequest(
  season: Season.fromJson(json['season'] as String),
  multiplier: (json['multiplier'] as num?)?.toDouble(),
  intervalDays: (json['intervalDays'] as num?)?.toInt(),
);

Map<String, dynamic> _$SeasonalSettingsUpdateRequestToJson(
  SeasonalSettingsUpdateRequest instance,
) => <String, dynamic>{
  'season': instance.season,
  'multiplier': instance.multiplier,
  'intervalDays': instance.intervalDays,
};
