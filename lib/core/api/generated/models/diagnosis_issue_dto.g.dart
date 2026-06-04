// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_issue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnosisIssueDto _$DiagnosisIssueDtoFromJson(Map<String, dynamic> json) =>
    DiagnosisIssueDto(
      code: json['code'] as String,
      severity: DiagnosisIssueDtoSeverity.fromJson(json['severity'] as String),
      title: json['title'] as String,
    );

Map<String, dynamic> _$DiagnosisIssueDtoToJson(DiagnosisIssueDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'severity': instance.severity,
      'title': instance.title,
    };
