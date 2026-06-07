// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_locations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedLocationsResponse _$SharedLocationsResponseFromJson(
  Map<String, dynamic> json,
) => SharedLocationsResponse(
  locations: (json['locations'] as List<dynamic>)
      .map((e) => SharedLocationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SharedLocationsResponseToJson(
  SharedLocationsResponse instance,
) => <String, dynamic>{'locations': instance.locations};
