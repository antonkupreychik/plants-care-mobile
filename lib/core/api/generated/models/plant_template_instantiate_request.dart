// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_template_instantiate_request.g.dart';

@JsonSerializable()
class PlantTemplateInstantiateRequest {
  const PlantTemplateInstantiateRequest({
    required this.name,
  });
  
  factory PlantTemplateInstantiateRequest.fromJson(Map<String, Object?> json) => _$PlantTemplateInstantiateRequestFromJson(json);
  
  /// Имя нового растения.
  final String name;

  Map<String, Object?> toJson() => _$PlantTemplateInstantiateRequestToJson(this);
}
