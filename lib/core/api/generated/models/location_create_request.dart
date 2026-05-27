// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'location_create_request.g.dart';

@JsonSerializable()
class LocationCreateRequest {
  const LocationCreateRequest({
    required this.name,
    this.emoji,
  });
  
  factory LocationCreateRequest.fromJson(Map<String, Object?> json) => _$LocationCreateRequestFromJson(json);
  
  final String name;
  final String? emoji;

  Map<String, Object?> toJson() => _$LocationCreateRequestToJson(this);
}
