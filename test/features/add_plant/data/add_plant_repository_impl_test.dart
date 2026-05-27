import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/species_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_species_summary_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_detail_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/species_summary_dto.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/add_plant/data/add_plant_repository_impl.dart';
import 'package:plantcare_mobile/features/add_plant/domain/care_difficulty.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockSpeciesClient extends Mock implements SpeciesClient {}

class _MockPlantsClient extends Mock implements PlantsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

PageResponseSpeciesSummaryDto _speciesPage(List<SpeciesSummaryDto> items) =>
    PageResponseSpeciesSummaryDto(
      items: items,
      total: items.length,
      offset: 0,
      limit: 20,
    );

PlantDto _plant(int id) => PlantDto(id: id, name: 'Фикус', archived: false);

void main() {
  setUpAll(() {
    registerFallbackValue(const PlantCreateRequest(name: 'x'));
    registerFallbackValue(AuthScope.none);
  });

  late _MockApi api;
  late _MockSpeciesClient species;
  late _MockPlantsClient plants;
  late AddPlantRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    species = _MockSpeciesClient();
    plants = _MockPlantsClient();
    when(() => api.species).thenReturn(species);
    when(() => api.plants).thenReturn(plants);
    repo = AddPlantRepositoryImpl(api);
  });

  group('searchSpecies', () {
    test('should_pass_query_limit_and_none_scope_and_map_items', () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _speciesPage(const [
            SpeciesSummaryDto(id: 1, name: 'Фикус', careDifficulty: 'EASY'),
            SpeciesSummaryDto(id: 2, name: 'Монстера'),
          ]));

      final result = await repo.searchSpecies(query: 'фик', limit: 5);

      final list = (result as Success).value;
      expect(list, hasLength(2));
      expect(list.first.id, 1);
      expect(list.first.careDifficulty, CareDifficulty.easy);

      final captured = verify(() => species.listSpecies(
            q: captureAny(named: 'q'),
            offset: any(named: 'offset'),
            limit: captureAny(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured;
      expect(captured[0], 'фик');
      expect(captured[1], 5);
      // Auth-слот: публичный справочник идёт со scope none.
      expect((captured[2] as Map)[kAuthScopeExtraKey], AuthScope.none);
    });

    test('should_return_empty_success_when_no_items', () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _speciesPage(const []));

      final result = await repo.searchSpecies(query: '', limit: 20);

      expect((result as Success).value, isEmpty);
    });

    test('should_return_failure_with_ApiError_when_DioException_carries_it',
        () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.searchSpecies(query: 'x', limit: 20);

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => species.listSpecies(
            q: any(named: 'q'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.searchSpecies(query: 'x', limit: 20);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('getSpeciesDetail', () {
    test('should_pass_id_and_none_scope_and_map_detail', () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const SpeciesDetailDto(
            id: 9,
            name: 'Фикус',
            wateringDays: 7,
            careDifficulty: 'HARD',
            description: 'Описание',
          ));

      final result = await repo.getSpeciesDetail(9);

      final detail = (result as Success).value;
      expect(detail.summary.id, 9);
      expect(detail.summary.careDifficulty, CareDifficulty.hard);
      expect(detail.description, 'Описание');

      final captured = verify(() => species.getSpecies(
            id: captureAny(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured;
      expect(captured[0], 9);
      expect((captured[1] as Map)[kAuthScopeExtraKey], AuthScope.none);
    });

    test('should_return_failure_when_DioException', () async {
      when(() => species.getSpecies(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getSpeciesDetail(9);

      expect((result as Failure).error, const ApiError.notFound());
    });
  });

  group('createPlant', () {
    test('should_send_user_scope_with_placeholder_userId_not_hardcoded_identity',
        () async {
      when(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(77));

      await repo.createPlant(name: 'Фикус', locationId: 3, notes: 'на окне');

      final captured = verify(() => plants.createPlant(
            xUserId: captureAny(named: 'xUserId'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured;
      // Auth-слот: scope user (X-User-Id ставит интерсептор). Identity НЕ
      // хардкодится в data — placeholder перезаписывается AuthInterceptor.
      // Проверяем именно placeholder (0), а не конкретный USER_ID.
      expect(captured[0], 0);
      expect((captured[1] as Map)[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_build_request_body_with_all_fields', () async {
      when(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(77));

      await repo.createPlant(name: 'Фикус', locationId: 3, notes: 'на окне');

      final body = verify(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as PlantCreateRequest;
      expect(body.name, 'Фикус');
      expect(body.locationId, 3);
      expect(body.notes, 'на окне');
    });

    test('should_build_request_body_with_null_location_and_notes', () async {
      when(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(77));

      await repo.createPlant(name: 'Фикус');

      final body = verify(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as PlantCreateRequest;
      expect(body.name, 'Фикус');
      expect(body.locationId, isNull);
      expect(body.notes, isNull);
    });

    test('should_return_success_with_plant_id_from_PlantDto', () async {
      when(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(123));

      final result = await repo.createPlant(name: 'Фикус');

      expect((result as Success).value, 123);
    });

    test('should_return_failure_with_ApiError_without_rethrow', () async {
      when(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.conflict()));

      final result = await repo.createPlant(name: 'Фикус');

      expect((result as Failure).error, const ApiError.conflict());
    });

    test('should_return_failure_unknown_when_error_not_ApiError', () async {
      when(() => plants.createPlant(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.createPlant(name: 'Фикус');

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
