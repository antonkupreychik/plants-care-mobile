import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/take_cutting/data/take_cutting_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

PlantDto _plant(int id) => PlantDto(id: id, name: 'Моник', archived: false);

void main() {
  setUpAll(() {
    registerFallbackValue(const PlantCreateRequest(name: 'x'));
    registerFallbackValue(AuthScope.none);
  });

  late _MockApi api;
  late _MockPlantsClient plants;
  late TakeCuttingRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    plants = _MockPlantsClient();
    when(() => api.plants).thenReturn(plants);
    repo = TakeCuttingRepositoryImpl(api);
  });

  group('createCutting', () {
    test('should_send_name_and_parentPlantId_in_request_body', () async {
      when(() => plants.createPlant(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(77));

      await repo.createCutting(name: 'Моник', parentPlantId: 42);

      final body = verify(() => plants.createPlant(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as PlantCreateRequest;
      expect(body.name, 'Моник');
      // Связь с родителем — главное, что отличает черенок от обычного создания.
      expect(body.parentPlantId, 42);
    });

    test('should_send_user_scope_not_hardcoded_identity', () async {
      when(() => plants.createPlant(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(77));

      await repo.createCutting(name: 'Моник', parentPlantId: 42);

      final extras = verify(() => plants.createPlant(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(extras[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_success_with_plant_id_from_PlantDto', () async {
      when(() => plants.createPlant(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(123));

      final result = await repo.createCutting(name: 'Моник', parentPlantId: 1);

      expect((result as Success).value, 123);
    });

    test('should_return_failure_with_ApiError_without_rethrow', () async {
      when(() => plants.createPlant(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.createCutting(name: 'Моник', parentPlantId: 1);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_error_not_ApiError', () async {
      when(() => plants.createPlant(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.createCutting(name: 'Моник', parentPlantId: 1);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
