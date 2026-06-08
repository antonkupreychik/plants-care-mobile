import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plant_events_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_page_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_type.dart'
    as dto;
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/plant_events/data/plant_event_repository_impl.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_events_page.dart';

class _MockClient extends Mock implements PlantEventsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/plants/7/events'),
      error: error,
    );

const _plantId = 7;

PlantEventDto _dto(
  int id,
  dto.PlantEventType type, {
  String? comment,
}) =>
    PlantEventDto(
      id: id,
      eventType: type,
      eventDate: DateTime.utc(2026, 6, 1, 9),
      comment: comment,
    );

PlantEventsPage _success(Result<PlantEventsPage> r) =>
    (r as Success<PlantEventsPage>).value;

void main() {
  setUpAll(() {
    registerFallbackValue(
      const PlantEventRequest(eventType: dto.PlantEventType.transplant),
    );
  });

  late _MockClient client;
  late PlantEventRepositoryImpl repo;

  setUp(() {
    client = _MockClient();
    repo = PlantEventRepositoryImpl(client);
  });

  void stubGet(PlantEventPageResponse response) {
    when(() => client.getPlantEvents(
          id: any(named: 'id'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: any(named: 'extras'),
        )).thenAnswer((_) async => response);
  }

  group('getEvents', () {
    test('should_pass_plantId_limit_offset_to_client', () async {
      stubGet(
        const PlantEventPageResponse(items: [], total: 0, limit: 5, offset: 0),
      );

      await repo.getEvents(_plantId, limit: 5, offset: 10);

      verify(() => client.getPlantEvents(
            id: _plantId,
            limit: 5,
            offset: 10,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('should_send_user_authScope_in_extras', () async {
      stubGet(
        const PlantEventPageResponse(items: [], total: 0, limit: 20, offset: 0),
      );

      await repo.getEvents(_plantId);

      final captured = verify(() => client.getPlantEvents(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_map_dto_event_types_to_domain', () async {
      stubGet(
        PlantEventPageResponse(
          items: [
            _dto(3, dto.PlantEventType.pruning, comment: 'Сухие листья'),
            _dto(2, dto.PlantEventType.soilChange),
            _dto(1, dto.PlantEventType.transplant),
          ],
          total: 3,
          limit: 20,
          offset: 0,
        ),
      );

      final page = _success(await repo.getEvents(_plantId));

      expect(page.items, hasLength(3));
      expect(page.items[0].eventType, PlantEventType.pruning);
      expect(page.items[0].comment, 'Сухие листья');
      expect(page.items[1].eventType, PlantEventType.soilChange);
      expect(page.items[2].eventType, PlantEventType.transplant);
      // Даты нормализованы в UTC.
      expect(page.items.every((e) => e.eventDate.isUtc), isTrue);
    });

    test('should_echo_pagination_metadata_from_response', () async {
      stubGet(
        PlantEventPageResponse(
          items: [_dto(1, dto.PlantEventType.transplant)],
          total: 42,
          limit: 5,
          offset: 5,
        ),
      );

      final page = _success(await repo.getEvents(_plantId, limit: 5, offset: 5));

      expect(page.total, 42);
      expect(page.limit, 5);
      expect(page.offset, 5);
      expect(page.hasMore, isTrue);
    });

    test('should_skip_events_with_unrecognized_type', () async {
      stubGet(
        PlantEventPageResponse(
          items: [
            _dto(2, dto.PlantEventType.transplant),
            _dto(1, dto.PlantEventType.$unknown),
          ],
          total: 2,
          limit: 20,
          offset: 0,
        ),
      );

      final page = _success(await repo.getEvents(_plantId));

      // Нераспознанный тип пропущен, total — echo backend (не пересчитываем).
      expect(page.items, hasLength(1));
      expect(page.items.single.eventType, PlantEventType.transplant);
      expect(page.total, 2);
    });

    test('should_return_failure_when_client_throws_api_error', () async {
      when(() => client.getPlantEvents(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.getEvents(_plantId);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_unknown_failure_when_error_not_api_error', () async {
      when(() => client.getPlantEvents(
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('raw string'));

      final result = await repo.getEvents(_plantId);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('addEvent', () {
    void stubCreate(PlantEventDto response) {
      when(() => client.createPlantEvent(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => response);
    }

    test('should_send_plantId_mapped_type_and_user_scope', () async {
      stubCreate(_dto(10, dto.PlantEventType.pestTreatment));

      await repo.addEvent(_plantId, PlantEventType.pestTreatment);

      final captured = verify(() => client.createPlantEvent(
            id: _plantId,
            body: captureAny(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured;
      final body = captured[0] as PlantEventRequest;
      final extras = captured[1] as Map<String, dynamic>;
      expect(body.eventType, dto.PlantEventType.pestTreatment);
      expect(extras[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_created_event_mapped_to_domain', () async {
      stubCreate(_dto(10, dto.PlantEventType.transplant, comment: null));

      final result = await repo.addEvent(_plantId, PlantEventType.transplant);

      final event = (result as Success<PlantEvent>).value;
      expect(event.id, 10);
      expect(event.eventType, PlantEventType.transplant);
      expect(event.eventDate.isUtc, isTrue);
    });

    test('should_return_conflict_failure_on_dedup', () async {
      when(() => client.createPlantEvent(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.conflict()));

      final result =
          await repo.addEvent(_plantId, PlantEventType.transplant);

      expect((result as Failure).error, const ApiError.conflict());
    });
  });
}
