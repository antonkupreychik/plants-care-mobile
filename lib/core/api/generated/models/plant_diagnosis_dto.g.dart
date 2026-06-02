// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_diagnosis_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantDiagnosisDto _$PlantDiagnosisDtoFromJson(Map<String, dynamic> json) =>
    PlantDiagnosisDto(
      issues: (json['issues'] as List<dynamic>)
          .map((e) => DiagnosisIssueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PlantDiagnosisDtoToJson(PlantDiagnosisDto instance) =>
    <String, dynamic>{
      'issues': instance.issues,
      'recommendations': instance.recommendations,
    };
