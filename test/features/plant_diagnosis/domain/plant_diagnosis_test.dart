import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_issue.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_severity.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/plant_diagnosis.dart';

DiagnosisIssue _issue(String code) => DiagnosisIssue(
      code: code,
      severity: DiagnosisSeverity.low,
      title: 'Issue $code',
    );

void main() {
  group('PlantDiagnosis.isHealthy', () {
    test('should_be_true_when_issues_and_recommendations_are_both_empty', () {
      final diagnosis = PlantDiagnosis(
        issues: const [],
        recommendations: const [],
      );

      expect(diagnosis.isHealthy, isTrue);
    });

    test('should_be_false_when_issues_are_non_empty', () {
      final diagnosis = PlantDiagnosis(
        issues: [_issue('UNDERWATERED')],
        recommendations: const [],
      );

      expect(diagnosis.isHealthy, isFalse);
    });

    test('should_be_false_when_recommendations_are_non_empty', () {
      // Backend отдаёт пустые issues + рекомендацию «добавьте данные»
      // когда записей ухода меньше порога. isHealthy в этом случае false.
      final diagnosis = PlantDiagnosis(
        issues: const [],
        recommendations: const ['Продолжайте вести журнал'],
      );

      expect(diagnosis.isHealthy, isFalse);
    });

    test('should_be_false_when_both_issues_and_recommendations_non_empty', () {
      final diagnosis = PlantDiagnosis(
        issues: [_issue('LOW_HUMIDITY')],
        recommendations: const ['Увлажните воздух'],
      );

      expect(diagnosis.isHealthy, isFalse);
    });
  });
}
