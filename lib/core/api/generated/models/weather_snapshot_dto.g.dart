// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_snapshot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherSnapshotDto _$WeatherSnapshotDtoFromJson(Map<String, dynamic> json) =>
    WeatherSnapshotDto(
      available: json['available'] as bool,
      humidityPercent: (json['humidityPercent'] as num?)?.toInt(),
      recommendation: json['recommendation'] == null
          ? null
          : WeatherSnapshotDtoRecommendation.fromJson(
              json['recommendation'] as String,
            ),
      fetchedAt: json['fetchedAt'] == null
          ? null
          : DateTime.parse(json['fetchedAt'] as String),
      fromCache: json['fromCache'] as bool?,
    );

Map<String, dynamic> _$WeatherSnapshotDtoToJson(WeatherSnapshotDto instance) =>
    <String, dynamic>{
      'available': instance.available,
      'humidityPercent': instance.humidityPercent,
      'recommendation': instance.recommendation,
      'fetchedAt': instance.fetchedAt?.toIso8601String(),
      'fromCache': instance.fromCache,
    };
