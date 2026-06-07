// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_template_create_request.g.dart';

@JsonSerializable()
class PlantTemplateCreateRequest {
  const PlantTemplateCreateRequest({
    required this.name,
    this.fromPlantId,
  });
  
  factory PlantTemplateCreateRequest.fromJson(Map<String, Object?> json) => _$PlantTemplateCreateRequestFromJson(json);
  
  final String name;

  /// ID существующего растения пользователя, из которого копировать.
  /// активные расписания ухода. Если не указан — шаблон создаётся.
  /// без правил (пустой каркас).
  ///
  final int? fromPlantId;

  Map<String, Object?> toJson() => _$PlantTemplateCreateRequestToJson(this);
}
