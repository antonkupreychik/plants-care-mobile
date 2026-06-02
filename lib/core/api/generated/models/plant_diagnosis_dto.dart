// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'diagnosis_issue_dto.dart';

part 'plant_diagnosis_dto.g.dart';

/// Результат пассивной диагностики растения (mobile screen 15, issue #193).
/// Форма ответа всегда `{ issues, recommendations }` — даже когда данных мало.
/// или растение здорово (тогда массивы пустые / содержат только подсказку).
///
@JsonSerializable()
class PlantDiagnosisDto {
  const PlantDiagnosisDto({
    required this.issues,
    required this.recommendations,
  });
  
  factory PlantDiagnosisDto.fromJson(Map<String, Object?> json) => _$PlantDiagnosisDtoFromJson(json);
  
  /// Выявленные проблемы, отсортированы по severity (HIGH → LOW).
  final List<DiagnosisIssueDto> issues;

  /// Рекомендации, собранные по проблемам (в том же порядке) с дедупликацией.
  ///
  final List<String> recommendations;

  Map<String, Object?> toJson() => _$PlantDiagnosisDtoToJson(this);
}
