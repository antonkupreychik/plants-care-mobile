// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_template_care_rule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantTemplateCareRuleDto _$PlantTemplateCareRuleDtoFromJson(
  Map<String, dynamic> json,
) => PlantTemplateCareRuleDto(
  careType: PlantTemplateCareRuleDtoCareType.fromJson(
    json['careType'] as String,
  ),
  intervalDays: (json['intervalDays'] as num).toInt(),
);

Map<String, dynamic> _$PlantTemplateCareRuleDtoToJson(
  PlantTemplateCareRuleDto instance,
) => <String, dynamic>{
  'careType': instance.careType,
  'intervalDays': instance.intervalDays,
};
