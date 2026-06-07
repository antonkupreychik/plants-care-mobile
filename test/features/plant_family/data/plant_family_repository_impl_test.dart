import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_family_member_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_family_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/plant_family/data/plant_family_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

void main() {
  late _MockApi api;
  late _MockPlantsClient plants;
  late PlantFamilyRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    plants = _MockPlantsClient();
    when(() => api.plants).thenReturn(plants);
    repo = PlantFamilyRepositoryImpl(api);
  });

  group('getFamily', () {
    test('should_map_parent_and_children', () async {
      when(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantFamilyResponse(
          parent: PlantFamilyMemberDto(id: 1, name: 'Моника'),
          children: [
            PlantFamilyMemberDto(id: 2, name: 'Моник'),
            PlantFamilyMemberDto(id: 3, name: 'Дочка'),
          ],
        ),
      );

      final family = (await repo.getFamily(42) as Success).value;

      expect(family.parent?.name, 'Моника');
      expect(family.children, hasLength(2));
      expect(family.hasRelations, isTrue);
    });

    test('should_map_lonely_plant_as_no_relations', () async {
      when(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantFamilyResponse(parent: null, children: []),
      );

      final family = (await repo.getFamily(42) as Success).value;

      expect(family.hasRelations, isFalse);
    });

    test('should_forward_plantId_to_client', () async {
      when(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantFamilyResponse(parent: null, children: []),
      );

      await repo.getFamily(77);

      verify(() => plants.getPlantFamily(
            id: 77,
            extras: any(named: 'extras'),
          )).called(1);
    });

    // Auth-слот: родословная ходит со scope user (как GET /plants/{id}).
    // Идентичность ставит интерсептор, не data — ловит молчаливую регрессию.
    test('should_send_user_authScope_in_extras', () async {
      when(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantFamilyResponse(parent: null, children: []),
      );

      await repo.getFamily(42);

      final captured = verify(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_when_DioException_carries_ApiError', () async {
      when(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getFamily(42);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_error_not_ApiError', () async {
      when(() => plants.getPlantFamily(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.getFamily(42);

      // Наружу не бросаем — заворачиваем в Result.failure(unknown).
      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
