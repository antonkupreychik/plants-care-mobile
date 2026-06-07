// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonalSettingsResponse _$SeasonalSettingsResponseFromJson(
  Map<String, dynamic> json,
) => SeasonalSettingsResponse(
  enabled: json['enabled'] as bool,
  mode: SeasonalSettingsResponseMode.fromJson(json['mode'] as String),
  seasons: (json['seasons'] as List<dynamic>)
      .map((e) => SeasonSettings.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SeasonalSettingsResponseToJson(
  SeasonalSettingsResponse instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'mode': instance.mode,
  'seasons': instance.seasons,
};
