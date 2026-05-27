// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_update_request.g.dart';

/// Тело PUT /api/v1/plants/{id}. Все поля опциональны.
@JsonSerializable()
class PlantUpdateRequest {
  const PlantUpdateRequest({
    this.name,
    this.notes,
    this.locationId,
  });
  
  factory PlantUpdateRequest.fromJson(Map<String, Object?> json) => _$PlantUpdateRequestFromJson(json);
  
  final String? name;
  final String? notes;
  final int? locationId;

  Map<String, Object?> toJson() => _$PlantUpdateRequestToJson(this);
}
