// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonSettings _$SeasonSettingsFromJson(Map<String, dynamic> json) =>
    SeasonSettings(
      season: Season.fromJson(json['season'] as String),
      multiplier: (json['multiplier'] as num).toDouble(),
      intervalDays: (json['intervalDays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SeasonSettingsToJson(SeasonSettings instance) =>
    <String, dynamic>{
      'season': instance.season,
      'multiplier': instance.multiplier,
      'intervalDays': instance.intervalDays,
    };
