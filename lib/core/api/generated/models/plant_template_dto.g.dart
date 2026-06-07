// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantTemplateDto _$PlantTemplateDtoFromJson(Map<String, dynamic> json) =>
    PlantTemplateDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      careRules: (json['careRules'] as List<dynamic>)
          .map(
            (e) => PlantTemplateCareRuleDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PlantTemplateDtoToJson(PlantTemplateDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'careRules': instance.careRules,
      'createdAt': instance.createdAt.toIso8601String(),
    };
