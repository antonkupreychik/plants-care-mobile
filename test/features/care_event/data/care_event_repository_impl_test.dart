import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/care_events_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plant_history_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/create_care_event_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_history_response.dart';
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

class _MockPlantHistoryClient extends Mock implements PlantHistoryClient {}

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
  late _MockPlantHistoryClient historyClient;
  late CareEventRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockCareEventsClient();
    historyClient = _MockPlantHistoryClient();
    when(() => api.careEvents).thenReturn(client);
    when(() => api.plantHistory).thenReturn(historyClient);
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

  group('priorCareEventCount success', () {
    test('should_map_total_from_history_response', () async {
      when(() => historyClient.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantHistoryResponse(
          items: <CareEventResponse>[],
          total: 5,
          limit: 1,
          offset: 0,
        ),
      );

      final result = await repo.priorCareEventCount(42);

      expect((result as Success).value, 5);
    });

    test('should_request_plantId_with_minimal_page', () async {
      // limit:1, offset:0 — нужен только `total`, записи не тянем.
      when(() => historyClient.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantHistoryResponse(
          items: <CareEventResponse>[],
          total: 0,
          limit: 1,
          offset: 0,
        ),
      );

      await repo.priorCareEventCount(42);

      verify(() => historyClient.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: 42,
            limit: 1,
            offset: 0,
            extras: any(named: 'extras'),
          )).called(1);
    });
  });

  group('priorCareEventCount auth slot', () {
    test('should_send_chat_authScope_and_not_leak_hardcoded_identity',
        () async {
      when(() => historyClient.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const PlantHistoryResponse(
          items: <CareEventResponse>[],
          total: 0,
          limit: 1,
          offset: 0,
        ),
      );

      await repo.priorCareEventCount(42);

      final captured = verify(() => historyClient.getPlantHistory(
            xChatId: captureAny(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: captureAny(named: 'extras'),
          )).captured;
      final chatId = captured[0] as int;
      final extras = captured[1] as Map<String, dynamic>;

      // Scope chat → X-Chat-Id ставит AuthInterceptor из AuthSession.
      expect(extras[kAuthScopeExtraKey], AuthScope.chat);
      // Идентичность НЕ хардкодится в data-слое: заглушка-заголовок == 0,
      // никакого dev USER_ID/CHAT_ID не утекает мимо интерцептора.
      expect(chatId, 0);
    });
  });

  group('priorCareEventCount failures', () {
    test('should_return_failure_with_ApiError_when_DioException_carries_it',
        () async {
      when(() => historyClient.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.priorCareEventCount(42);

      expect((result as Failure).error, const ApiError.notFound());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => historyClient.getPlantHistory(
            xChatId: any(named: 'xChatId'),
            id: any(named: 'id'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.priorCareEventCount(42);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
