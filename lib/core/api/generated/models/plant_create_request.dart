// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_create_request.g.dart';

/// Тело POST /api/v1/plants.
@JsonSerializable()
class PlantCreateRequest {
  const PlantCreateRequest({
    required this.name,
    this.notes,
    this.locationId,
  });
  
  factory PlantCreateRequest.fromJson(Map<String, Object?> json) => _$PlantCreateRequestFromJson(json);
  
  /// Имя нового растения. Обязательно, не пустое.
  final String name;

  /// Опциональные заметки пользователя.
  final String? notes;

  /// Идентификатор локации. Если не задан, используется дефолтная локация пользователя.
  final int? locationId;

  Map<String, Object?> toJson() => _$PlantCreateRequestToJson(this);
}
