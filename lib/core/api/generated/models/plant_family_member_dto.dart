// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_family_member_dto.g.dart';

/// Короткое представление растения в родословной.
@JsonSerializable()
class PlantFamilyMemberDto {
  const PlantFamilyMemberDto({
    required this.id,
    required this.name,
  });
  
  factory PlantFamilyMemberDto.fromJson(Map<String, Object?> json) => _$PlantFamilyMemberDtoFromJson(json);
  
  final int id;
  final String name;

  Map<String, Object?> toJson() => _$PlantFamilyMemberDtoToJson(this);
}
