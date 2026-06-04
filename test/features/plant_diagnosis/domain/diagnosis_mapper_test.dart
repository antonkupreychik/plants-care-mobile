import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/diagnosis_issue_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/diagnosis_issue_dto_severity.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_diagnosis_dto.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/data/diagnosis_mapper.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_severity.dart';

DiagnosisIssueDto _issueDto({
  required DiagnosisIssueDtoSeverity severity,
  String code = 'UNDERWATERED',
  String title = 'Недополив',
}) =>
    DiagnosisIssueDto(code: code, severity: severity, title: title);

void main() {
  group('DiagnosisIssueDtoSeverityMapper', () {
    test('should_map_high_to_DiagnosisSeverity_high', () {
      final result = DiagnosisIssueDtoSeverity.high.toDomain();

      expect(result, DiagnosisSeverity.high);
    });

    test('should_map_medium_to_DiagnosisSeverity_medium', () {
      final result = DiagnosisIssueDtoSeverity.medium.toDomain();

      expect(result, DiagnosisSeverity.medium);
    });

    test('should_map_low_to_DiagnosisSeverity_low', () {
      final result = DiagnosisIssueDtoSeverity.low.toDomain();

      expect(result, DiagnosisSeverity.low);
    });

    test('should_map_dollar_unknown_to_DiagnosisSeverity_unknown', () {
      final result = DiagnosisIssueDtoSeverity.$unknown.toDomain();

      expect(result, DiagnosisSeverity.unknown);
    });
  });

  group('DiagnosisIssueDtoMapper', () {
    test('should_preserve_code_severity_and_title', () {
      final dto = _issueDto(
        severity: DiagnosisIssueDtoSeverity.high,
        code: 'UNDERWATERED',
        title: 'Недополив',
      );

      final issue = dto.toDomain();

      expect(issue.code, 'UNDERWATERED');
      expect(issue.severity, DiagnosisSeverity.high);
      expect(issue.title, 'Недополив');
    });
  });

  group('PlantDiagnosisDtoMapper', () {
    test('should_map_empty_arrays_to_empty_lists', () {
      final dto = const PlantDiagnosisDto(
        issues: [],
        recommendations: [],
      );

      final diagnosis = dto.toDomain();

      expect(diagnosis.issues, isEmpty);
      expect(diagnosis.recommendations, isEmpty);
      expect(diagnosis.isHealthy, isTrue);
    });

    test('should_map_all_issue_fields_and_recommendations', () {
      final dto = PlantDiagnosisDto(
        issues: [
          _issueDto(
            severity: DiagnosisIssueDtoSeverity.high,
            code: 'UNDERWATERED',
            title: 'Недополив',
          ),
          _issueDto(
            severity: DiagnosisIssueDtoSeverity.medium,
            code: 'LOW_HUMIDITY',
            title: 'Низкая влажность',
          ),
        ],
        recommendations: const [
          'Поливайте обильнее',
          'Используйте увлажнитель',
        ],
      );

      final diagnosis = dto.toDomain();

      expect(diagnosis.issues, hasLength(2));
      expect(diagnosis.issues[0].code, 'UNDERWATERED');
      expect(diagnosis.issues[0].severity, DiagnosisSeverity.high);
      expect(diagnosis.issues[0].title, 'Недополив');
      expect(diagnosis.issues[1].code, 'LOW_HUMIDITY');
      expect(diagnosis.issues[1].severity, DiagnosisSeverity.medium);
      expect(diagnosis.recommendations, hasLength(2));
      expect(diagnosis.recommendations[0], 'Поливайте обильнее');
      expect(diagnosis.recommendations[1], 'Используйте увлажнитель');
      expect(diagnosis.isHealthy, isFalse);
    });

    test('should_preserve_unknown_severity_from_dto', () {
      final dto = PlantDiagnosisDto(
        issues: [
          _issueDto(
            severity: DiagnosisIssueDtoSeverity.$unknown,
            code: 'FUTURE_CODE',
            title: 'Новая проблема',
          ),
        ],
        recommendations: const [],
      );

      final diagnosis = dto.toDomain();

      expect(diagnosis.issues.single.severity, DiagnosisSeverity.unknown);
      expect(diagnosis.issues.single.code, 'FUTURE_CODE');
    });
  });
}
