// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'shared_location_dto.dart';

part 'shared_locations_response.g.dart';

@JsonSerializable()
class SharedLocationsResponse {
  const SharedLocationsResponse({
    required this.locations,
  });
  
  factory SharedLocationsResponse.fromJson(Map<String, Object?> json) => _$SharedLocationsResponseFromJson(json);
  
  final List<SharedLocationDto> locations;

  Map<String, Object?> toJson() => _$SharedLocationsResponseToJson(this);
}
