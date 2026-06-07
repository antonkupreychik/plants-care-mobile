// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_strip_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherStripBlock _$WeatherStripBlockFromJson(Map<String, dynamic> json) =>
    WeatherStripBlock(
      type: WeatherStripBlockType.fromJson(json['type'] as String),
      available: json['available'] as bool,
      humidityPercent: (json['humidityPercent'] as num?)?.toInt(),
      recommendation: json['recommendation'] == null
          ? null
          : WeatherStripBlockRecommendation.fromJson(
              json['recommendation'] as String,
            ),
      fetchedAt: json['fetchedAt'] == null
          ? null
          : DateTime.parse(json['fetchedAt'] as String),
      fromCache: json['fromCache'] as bool?,
    );

Map<String, dynamic> _$WeatherStripBlockToJson(WeatherStripBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
      'available': instance.available,
      'humidityPercent': instance.humidityPercent,
      'recommendation': instance.recommendation,
      'fetchedAt': instance.fetchedAt?.toIso8601String(),
      'fromCache': instance.fromCache,
    };
