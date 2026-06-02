// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'diagnosis_issue_dto_severity.dart';

part 'diagnosis_issue_dto.g.dart';

/// Отдельная выявленная проблема растения.
@JsonSerializable()
class DiagnosisIssueDto {
  const DiagnosisIssueDto({
    required this.code,
    required this.severity,
    required this.title,
  });
  
  factory DiagnosisIssueDto.fromJson(Map<String, Object?> json) => _$DiagnosisIssueDtoFromJson(json);
  
  /// Семантический код проблемы (`UNDERWATERED`, `UNDERFED`,.
  /// `LOW_HUMIDITY`, `SOIL_CHECK_DUE`, `NEGLECTED`, ...). Строка —.
  /// а не enum — для forward-совместимости с новыми кодами.
  ///
  final String code;

  /// Серьёзность проблемы.
  final DiagnosisIssueDtoSeverity severity;

  /// Человекочитаемый заголовок проблемы (локализован).
  final String title;

  Map<String, Object?> toJson() => _$DiagnosisIssueDtoToJson(this);
}
