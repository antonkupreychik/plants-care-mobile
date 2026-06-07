// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'weather_location_request.g.dart';

/// Тело `PUT /api/v1/me/weather-location`. Оба поля обязательны.
///
@JsonSerializable()
class WeatherLocationRequest {
  const WeatherLocationRequest({
    required this.lat,
    required this.lon,
  });
  
  factory WeatherLocationRequest.fromJson(Map<String, Object?> json) => _$WeatherLocationRequestFromJson(json);
  
  /// Широта в градусах (WGS-84).
  final double lat;

  /// Долгота в градусах (WGS-84).
  final double lon;

  Map<String, Object?> toJson() => _$WeatherLocationRequestToJson(this);
}
