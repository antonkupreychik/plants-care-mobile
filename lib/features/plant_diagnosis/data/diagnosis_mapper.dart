import '../../../core/api/generated/models/diagnosis_issue_dto.dart';
import '../../../core/api/generated/models/diagnosis_issue_dto_severity.dart';
import '../../../core/api/generated/models/plant_diagnosis_dto.dart';
import '../domain/diagnosis_issue.dart';
import '../domain/diagnosis_severity.dart';
import '../domain/plant_diagnosis.dart';

/// Маппинг DTO диагностики → domain-модели (MADR-002 / MADR-007).
///
/// Явный, написанный руками маппер: сгенерированный код не трогаем.
/// Находится в data-слое — только здесь допустима зависимость от DTO.

extension PlantDiagnosisDtoMapper on PlantDiagnosisDto {
  PlantDiagnosis toDomain() => PlantDiagnosis(
        issues: issues.map((dto) => dto.toDomain()).toList(growable: false),
        recommendations: List.unmodifiable(recommendations),
      );
}

extension DiagnosisIssueDtoMapper on DiagnosisIssueDto {
  DiagnosisIssue toDomain() => DiagnosisIssue(
        code: code,
        severity: severity.toDomain(),
        title: title,
      );
}

extension DiagnosisIssueDtoSeverityMapper on DiagnosisIssueDtoSeverity {
  DiagnosisSeverity toDomain() => switch (this) {
        DiagnosisIssueDtoSeverity.high => DiagnosisSeverity.high,
        DiagnosisIssueDtoSeverity.medium => DiagnosisSeverity.medium,
        DiagnosisIssueDtoSeverity.low => DiagnosisSeverity.low,
        DiagnosisIssueDtoSeverity.$unknown => DiagnosisSeverity.unknown,
      };
}
