import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/status.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/archive/data/archive_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/plants'),
      error: error,
    );

const _archivedDto = PlantDto(
  id: 1,
  name: 'Алоэ',
  archived: true,
  speciesName: 'Алоэ Вера',
  note: 'Перелив',
  gifted: false,
  totalCareDays: 335,
  archivedAt: null,
);

const _giftedDto = PlantDto(
  id: 2,
  name: 'Босс',
  archived: true,
  speciesName: 'Бонсай',
  note: 'Подарили',
  gifted: true,
  totalCareDays: 1167,
  archivedAt: null,
);

void main() {
  setUpAll(() {
    registerFallbackValue(Status.archived);
  });

  late _MockApi api;
  late _MockPlantsClient plantsClient;
  late ArchiveRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    plantsClient = _MockPlantsClient();
    when(() => api.plants).thenReturn(plantsClient);
    repo = ArchiveRepositoryImpl(api);
  });

  group('getArchive', () {
    test(
        'should_return_success_with_mapped_plants_when_backend_returns_archived_list',
        () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const PageResponsePlantDto(
            items: [_archivedDto, _giftedDto],
            total: 2,
            offset: 0,
            limit: 100,
          ));

      final result = await repo.getArchive();

      final view = (result as Success).value;
      expect(view.plants, hasLength(2));
      expect(view.plants.first.id, 1);
      expect(view.plants.first.name, 'Алоэ');
      expect(view.plants.first.gifted, isFalse);
      expect(view.plants.last.gifted, isTrue);
      expect(view.retrospective, isNotNull);
    });

    test('should_send_status_archived_in_query', () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const PageResponsePlantDto(
            items: [],
            total: 0,
            offset: 0,
            limit: 100,
          ));

      await repo.getArchive();

      final captured = verify(() => plantsClient.listPlants(
            status: captureAny(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).captured.single as Status;
      expect(captured, Status.archived);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const PageResponsePlantDto(
            items: [],
            total: 0,
            offset: 0,
            limit: 100,
          ));

      await repo.getArchive();

      final captured = verify(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_empty_plants_and_null_retrospective_when_archive_empty',
        () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const PageResponsePlantDto(
            items: [],
            total: 0,
            offset: 0,
            limit: 100,
          ));

      final result = await repo.getArchive();

      final view = (result as Success).value;
      expect(view.plants, isEmpty);
      expect(view.retrospective, isNull);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getArchive();

      expect((result as Failure).error, const ApiError.network());
    });

    test(
        'should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('raw string'));

      final result = await repo.getArchive();

      expect((result as Failure).error, const ApiError.unknown());
    });

    test('should_return_failure_unauthorized_when_backend_rejects_auth',
        () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.unauthorized()));

      final result = await repo.getArchive();

      expect((result as Failure).error, const ApiError.unauthorized());
    });

    test(
        'should_set_retrospective_label_with_plant_count_when_plants_present',
        () async {
      when(() => plantsClient.listPlants(
            status: any(named: 'status'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const PageResponsePlantDto(
            items: [_archivedDto],
            total: 1,
            offset: 0,
            limit: 100,
          ));

      final result = await repo.getArchive();

      final view = (result as Success).value;
      expect(view.retrospective, isNotNull);
      expect(view.retrospective!.averageLivedLabel, contains('1'));
    });
  });
}
