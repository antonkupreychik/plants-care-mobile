// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_family_member_dto.dart';

part 'plant_family_response.g.dart';

/// Родословная растения — родитель и прямые потомки.
@JsonSerializable()
class PlantFamilyResponse {
  const PlantFamilyResponse({
    required this.children,
    this.parent,
  });
  
  factory PlantFamilyResponse.fromJson(Map<String, Object?> json) => _$PlantFamilyResponseFromJson(json);
  
  final PlantFamilyMemberDto? parent;
  final List<PlantFamilyMemberDto> children;

  Map<String, Object?> toJson() => _$PlantFamilyResponseToJson(this);
}
