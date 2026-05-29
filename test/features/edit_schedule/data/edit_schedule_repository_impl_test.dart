import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plant_schedules_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_schedule_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_schedule_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/edit_schedule_repository_impl.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/care_schedule_unit.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockSchedulesClient extends Mock implements PlantSchedulesClient {}

class _FakeUpdateRequest extends Fake implements CareScheduleUpdateRequest {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/plants/1/schedules'),
      error: error,
    );

CareScheduleDto _wateringDto({int every = 7}) => CareScheduleDto(
      type: 'WATERING',
      every: every,
      unit: 'DAY',
      enabled: true,
      amountMl: 200,
      nextDueAt: DateTime.utc(2026, 6, 1, 9),
    );

const _wateringDomain = PlantCareSchedule(
  type: CareTaskType.watering,
  rawType: 'WATERING',
  every: 5,
  unit: CareScheduleUnit.day,
  rawUnit: 'DAY',
  amountMl: 250,
  enabled: true,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeUpdateRequest());
  });

  late _MockApi api;
  late _MockSchedulesClient client;
  late EditScheduleRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockSchedulesClient();
    when(() => api.plantSchedules).thenReturn(client);
    repo = EditScheduleRepositoryImpl(api);
  });

  group('getSchedules', () {
    test('should_return_success_with_mapped_domain_list', () async {
      when(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => [_wateringDto()]);

      final result = await repo.getSchedules(1);

      final list = (result as Success).value;
      expect(list, hasLength(1));
      expect(list.first.type, CareTaskType.watering);
      expect(list.first.every, 7);
      expect(list.first.unit, CareScheduleUnit.day);
    });

    test('should_forward_plantId_as_path_id', () async {
      when(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => [_wateringDto()]);

      await repo.getSchedules(42);

      verify(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: 42,
            extras: any(named: 'extras'),
          )).called(1);
    });

    // Auth-слот: user-scoped, X-User-Id ставит интерсептор. Ловит молчаливую
    // регрессию scope при подключении реального auth.
    test('should_send_user_authScope_in_extras', () async {
      when(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const <CareScheduleDto>[]);

      await repo.getSchedules(1);

      final captured = verify(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_with_ApiError_from_DioException_without_throw',
        () async {
      when(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getSchedules(1);

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.listPlantSchedules(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.getSchedules(1);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('updateSchedule', () {
    test('should_return_success_with_updated_domain', () async {
      when(() => client.updatePlantSchedule(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            type: any(named: 'type'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _wateringDto(every: 5));

      final result = await repo.updateSchedule(1, _wateringDomain);

      final updated = (result as Success).value;
      expect(updated.type, CareTaskType.watering);
      expect(updated.every, 5);
      expect(updated.nextDueAt, DateTime.utc(2026, 6, 1, 9));
    });

    test('should_send_rawType_as_path_type_and_mapped_body', () async {
      when(() => client.updatePlantSchedule(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            type: any(named: 'type'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _wateringDto(every: 5));

      await repo.updateSchedule(7, _wateringDomain);

      final body = verify(() => client.updatePlantSchedule(
            xUserId: any(named: 'xUserId'),
            id: 7,
            type: 'WATERING',
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as CareScheduleUpdateRequest;
      // Тело собрано маппером из домена: every/unit(rawUnit)/amountMl/enabled.
      expect(body.every, 5);
      expect(body.unit, 'DAY');
      expect(body.amountMl, 250);
      expect(body.enabled, isTrue);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.updatePlantSchedule(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            type: any(named: 'type'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _wateringDto(every: 5));

      await repo.updateSchedule(1, _wateringDomain);

      final captured = verify(() => client.updatePlantSchedule(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            type: any(named: 'type'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_with_ApiError_without_throw', () async {
      when(() => client.updatePlantSchedule(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            type: any(named: 'type'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.conflict()));

      final result = await repo.updateSchedule(1, _wateringDomain);

      expect((result as Failure).error, const ApiError.conflict());
    });
  });
}
