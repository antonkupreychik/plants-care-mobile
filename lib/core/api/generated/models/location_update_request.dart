// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'location_update_request.g.dart';

/// Все поля опциональны.
@JsonSerializable()
class LocationUpdateRequest {
  const LocationUpdateRequest({
    this.name,
    this.emoji,
  });
  
  factory LocationUpdateRequest.fromJson(Map<String, Object?> json) => _$LocationUpdateRequestFromJson(json);
  
  final String? name;
  final String? emoji;

  Map<String, Object?> toJson() => _$LocationUpdateRequestToJson(this);
}
