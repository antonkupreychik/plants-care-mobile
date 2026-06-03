import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/diagnosis_issue_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/diagnosis_issue_dto_severity.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_diagnosis_dto.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/data/diagnosis_repository_impl.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_severity.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

const _plantId = 99;

PlantDiagnosisDto _healthyDto() => const PlantDiagnosisDto(
      issues: [],
      recommendations: [],
    );

PlantDiagnosisDto _sickDto() => PlantDiagnosisDto(
      issues: [
        DiagnosisIssueDto(
          code: 'UNDERWATERED',
          severity: DiagnosisIssueDtoSeverity.high,
          title: 'Недополив',
        ),
      ],
      recommendations: const ['Полейте растение'],
    );

void main() {
  late _MockApi api;
  late _MockPlantsClient plants;
  late DiagnosisRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    plants = _MockPlantsClient();

    when(() => api.plants).thenReturn(plants);

    repo = DiagnosisRepositoryImpl(api);
  });

  group('getDiagnosis', () {
    test('should_return_success_with_mapped_diagnosis_when_api_succeeds',
        () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _sickDto());

      final result = await repo.getDiagnosis(_plantId);

      final diagnosis = (result as Success).value;
      expect(diagnosis.issues, hasLength(1));
      expect(diagnosis.issues.first.code, 'UNDERWATERED');
      expect(diagnosis.issues.first.severity, DiagnosisSeverity.high);
      expect(diagnosis.recommendations, hasLength(1));
      expect(diagnosis.recommendations.first, 'Полейте растение');
    });

    test('should_return_success_with_isHealthy_true_when_arrays_empty',
        () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _healthyDto());

      final result = await repo.getDiagnosis(_plantId);

      final diagnosis = (result as Success).value;
      expect(diagnosis.isHealthy, isTrue);
      expect(diagnosis.issues, isEmpty);
      expect(diagnosis.recommendations, isEmpty);
    });

    test('should_return_failure_with_ApiError_when_DioException_carries_ApiError',
        () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getDiagnosis(_plantId);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_DioException_error_is_not_ApiError',
        () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('unexpected string error'));

      final result = await repo.getDiagnosis(_plantId);

      expect((result as Failure).error, const ApiError.unknown());
    });

    // Auth-слот: getDiagnosis должен передавать scope user.
    // Регрессия: если scope сменится при подключении реального auth — тест упадёт.
    test('should_send_user_authScope_in_extras', () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _healthyDto());

      await repo.getDiagnosis(_plantId);

      final captured = verify(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_call_api_with_correct_plantId', () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _healthyDto());

      await repo.getDiagnosis(_plantId);

      verify(() => plants.getPlantDiagnosis(
            id: _plantId,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('should_return_failure_network_when_DioException_carries_network_error',
        () async {
      when(() => plants.getPlantDiagnosis(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getDiagnosis(_plantId);

      expect((result as Failure).error, const ApiError.network());
    });
  });
}
