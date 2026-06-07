// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_template_care_rule_dto.dart';

part 'plant_template_dto.g.dart';

/// Шаблон растения пользователя.
@JsonSerializable()
class PlantTemplateDto {
  const PlantTemplateDto({
    required this.id,
    required this.name,
    required this.careRules,
    required this.createdAt,
  });
  
  factory PlantTemplateDto.fromJson(Map<String, Object?> json) => _$PlantTemplateDtoFromJson(json);
  
  final int id;
  final String name;

  /// Правила ухода, сохранённые в шаблоне.
  final List<PlantTemplateCareRuleDto> careRules;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$PlantTemplateDtoToJson(this);
}
