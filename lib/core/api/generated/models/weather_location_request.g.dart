// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_location_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherLocationRequest _$WeatherLocationRequestFromJson(
  Map<String, dynamic> json,
) => WeatherLocationRequest(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$WeatherLocationRequestToJson(
  WeatherLocationRequest instance,
) => <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};
