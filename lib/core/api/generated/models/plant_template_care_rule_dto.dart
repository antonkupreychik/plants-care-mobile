// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_template_care_rule_dto_care_type.dart';

part 'plant_template_care_rule_dto.g.dart';

/// Одно правило ухода в шаблоне.
@JsonSerializable()
class PlantTemplateCareRuleDto {
  const PlantTemplateCareRuleDto({
    required this.careType,
    required this.intervalDays,
  });
  
  factory PlantTemplateCareRuleDto.fromJson(Map<String, Object?> json) => _$PlantTemplateCareRuleDtoFromJson(json);
  
  final PlantTemplateCareRuleDtoCareType careType;
  final int intervalDays;

  Map<String, Object?> toJson() => _$PlantTemplateCareRuleDtoToJson(this);
}
