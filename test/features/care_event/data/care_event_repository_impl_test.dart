import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/care_events_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/create_care_event_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_impl.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockCareEventsClient extends Mock implements CareEventsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/care-events'),
      error: error,
    );

CareEventDraft _draft({
  CareEventKind type = CareEventKind.water,
  String? clientId = 'uuid-1',
}) =>
    CareEventDraft(
      plantId: 42,
      type: type,
      performedAtUtc: DateTime.utc(2026, 5, 27, 8),
      clientId: clientId,
    );

CareEventResponse _response() => CareEventResponse(
      id: 7,
      plantId: 42,
      plantName: 'Фикус',
      type: CareEventType.water,
      performedAt: DateTime.utc(2026, 5, 27, 8),
      onTime: true,
      clientId: 'uuid-1',
    );

void main() {
  setUpAll(() {
    registerFallbackValue(
      CreateCareEventRequest(
        plantId: 0,
        type: CareEventType.water,
        performedAt: DateTime.utc(2026),
      ),
    );
  });

  late _MockApi api;
  late _MockCareEventsClient client;
  late CareEventRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockCareEventsClient();
    when(() => api.careEvents).thenReturn(client);
    repo = CareEventRepositoryImpl(api);
  });

  group('logCareEvent success', () {
    test('should_return_success_with_mapped_LoggedCareEvent', () async {
      when(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _response());

      final result = await repo.logCareEvent(_draft());

      final logged = (result as Success).value;
      expect(logged.id, 7);
      expect(logged.plantId, 42);
      expect(logged.type, CareEventKind.water);
      expect(logged.onTime, isTrue);
    });

    test('should_send_draft_fields_in_request_body', () async {
      when(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _response());

      await repo.logCareEvent(_draft(type: CareEventKind.fertilize));

      final body = verify(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as CreateCareEventRequest;
      expect(body.plantId, 42);
      expect(body.type, CareEventType.fertilize);
      expect(body.clientId, 'uuid-1');
      expect(body.performedAt.isUtc, isTrue);
    });
  });

  group('logCareEvent auth slot', () {
    test('should_send_chat_authScope_in_extras', () async {
      when(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _response());

      await repo.logCareEvent(_draft());

      final extras = verify(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(extras[kAuthScopeExtraKey], AuthScope.chat);
    });
  });

  group('logCareEvent validation', () {
    test('should_return_failure_badRequest_without_calling_api_when_type_unknown',
        () async {
      // unknown не отправляем: отсекаем до сети (api-contract §7).
      final result = await repo.logCareEvent(_draft(type: CareEventKind.unknown));

      expect((result as Failure).error, isA<BadRequestError>());
      verifyNever(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          ));
    });
  });

  group('logCareEvent failures', () {
    test('should_return_failure_with_ApiError_when_DioException_carries_it',
        () async {
      when(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.conflict()));

      final result = await repo.logCareEvent(_draft());

      expect((result as Failure).error, const ApiError.conflict());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.createCareEvent(
            xChatId: any(named: 'xChatId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.logCareEvent(_draft());

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
