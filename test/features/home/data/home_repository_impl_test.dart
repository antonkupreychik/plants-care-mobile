import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcate_mobile/core/api/generated/clients/locations_client.dart';
import 'package:plantcate_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcate_mobile/core/api/generated/clients/today_client.dart';
import 'package:plantcate_mobile/core/api/generated/models/location_dto.dart';
import 'package:plantcate_mobile/core/api/generated/models/page_response_plant_dto.dart';
import 'package:plantcate_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcate_mobile/core/api/generated/models/task_dto.dart';
import 'package:plantcate_mobile/core/api/generated/models/today_response.dart';
import 'package:plantcate_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcate_mobile/core/error/api_error.dart';
import 'package:plantcate_mobile/core/error/result.dart';
import 'package:plantcate_mobile/core/network/auth_scope.dart';
import 'package:plantcate_mobile/core/network/request_extra.dart';
import 'package:plantcate_mobile/features/home/data/home_repository_impl.dart';
import 'package:plantcate_mobile/features/home/domain/care_task_type.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockTodayClient extends Mock implements TodayClient {}

class _MockPlantsClient extends Mock implements PlantsClient {}

class _MockLocationsClient extends Mock implements LocationsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: error,
    );

void main() {
  late _MockApi api;
  late _MockTodayClient today;
  late _MockPlantsClient plants;
  late _MockLocationsClient locations;
  late HomeRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    today = _MockTodayClient();
    plants = _MockPlantsClient();
    locations = _MockLocationsClient();

    when(() => api.today).thenReturn(today);
    when(() => api.plants).thenReturn(plants);
    when(() => api.locations).thenReturn(locations);

    repo = HomeRepositoryImpl(api);
  });

  group('getTodayTasks', () {
    test('should_return_success_with_mapped_tasks_when_client_returns_dto',
        () async {
      when(() => today.getToday(
            xChatId: any(named: 'xChatId'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => TodayResponse(
          tasks: [
            TaskDto(
              scheduleId: 1,
              plantId: 2,
              plantName: 'Monstera',
              taskType: 'WATERING',
              nextDueAt: DateTime.utc(2026, 5, 27, 8),
            ),
          ],
          count: 1,
        ),
      );

      final result = await repo.getTodayTasks();

      expect(result, isA<Success<dynamic>>());
      final tasks = (result as Success).value;
      expect(tasks, hasLength(1));
      expect(tasks.single.plantName, 'Monstera');
      expect(tasks.single.type, CareTaskType.watering);
    });

    test('should_send_chat_authScope_in_extras', () async {
      when(() => today.getToday(
            xChatId: any(named: 'xChatId'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const TodayResponse(tasks: [], count: 0));

      await repo.getTodayTasks();

      final captured = verify(() => today.getToday(
            xChatId: any(named: 'xChatId'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.chat);
    });

    test('should_return_failure_notFound_when_DioException_carries_ApiError',
        () async {
      when(() => today.getToday(
            xChatId: any(named: 'xChatId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getTodayTasks();

      expect(result, isA<Failure<dynamic>>());
      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => today.getToday(
            xChatId: any(named: 'xChatId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string error'));

      final result = await repo.getTodayTasks();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('getPlants', () {
    test('should_return_success_with_mapped_plants', () async {
      when(() => plants.listPlants(
            xUserId: any(named: 'xUserId'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PageResponsePlantDto(
          items: [PlantDto(id: 1, name: 'Фикус', archived: false)],
          total: 1,
          offset: 0,
          limit: 50,
        ),
      );

      final result = await repo.getPlants();

      final list = (result as Success).value;
      expect(list, hasLength(1));
      expect(list.single.name, 'Фикус');
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => plants.listPlants(
            xUserId: any(named: 'xUserId'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PageResponsePlantDto(
          items: [],
          total: 0,
          offset: 0,
          limit: 50,
        ),
      );

      await repo.getPlants();

      final captured = verify(() => plants.listPlants(
            xUserId: any(named: 'xUserId'),
            limit: any(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_accessDenied_when_DioException_carries_it',
        () async {
      when(() => plants.listPlants(
            xUserId: any(named: 'xUserId'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.accessDenied()));

      final result = await repo.getPlants();

      expect((result as Failure).error, const ApiError.accessDenied());
    });
  });

  group('getLocations', () {
    test('should_return_success_with_mapped_locations', () async {
      when(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const [
          LocationDto(id: 1, name: 'Кухня', defaultLocation: true),
        ],
      );

      final result = await repo.getLocations();

      final list = (result as Success).value;
      expect(list.single.name, 'Кухня');
      expect(list.single.isDefault, isTrue);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const []);

      await repo.getLocations();

      final captured = verify(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getLocations();

      expect((result as Failure).error, const ApiError.network());
    });
  });
}
