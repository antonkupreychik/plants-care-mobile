import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_type.dart';
import 'package:plantcare_mobile/features/care_event/data/mappers/care_event_mapper.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

void main() {
  group('careEventTypeFromKind', () {
    test('should_map_water_to_CareEventType_water', () {
      expect(careEventTypeFromKind(CareEventKind.water), CareEventType.water);
    });

    test('should_map_spray_to_CareEventType_spray', () {
      expect(careEventTypeFromKind(CareEventKind.spray), CareEventType.spray);
    });

    test('should_map_fertilize_to_CareEventType_fertilize', () {
      expect(
        careEventTypeFromKind(CareEventKind.fertilize),
        CareEventType.fertilize,
      );
    });

    test('should_return_null_for_unknown_because_not_sendable', () {
      // unknown невалиден для отправки — маппер возвращает null, репозиторий
      // превращает это в ApiError.badRequest.
      expect(careEventTypeFromKind(CareEventKind.unknown), isNull);
    });
  });

  group('careEventKindFromType', () {
    test('should_map_water_to_kind_water', () {
      expect(careEventKindFromType(CareEventType.water), CareEventKind.water);
    });

    test('should_map_spray_to_kind_spray', () {
      expect(careEventKindFromType(CareEventType.spray), CareEventKind.spray);
    });

    test('should_map_fertilize_to_kind_fertilize', () {
      expect(
        careEventKindFromType(CareEventType.fertilize),
        CareEventKind.fertilize,
      );
    });

    test('should_map_dollar_unknown_to_kind_unknown', () {
      expect(
        careEventKindFromType(CareEventType.$unknown),
        CareEventKind.unknown,
      );
    });
  });

  group('CareEventDraftMapper.toRequest', () {
    CareEventDraft draftWith({
      required CareEventKind type,
      required DateTime performedAtUtc,
      String? note,
      String? clientId,
    }) =>
        CareEventDraft(
          plantId: 42,
          type: type,
          performedAtUtc: performedAtUtc,
          note: note,
          clientId: clientId,
        );

    test('should_map_fields_and_pass_dtoType_through', () {
      final draft = draftWith(
        type: CareEventKind.spray,
        performedAtUtc: DateTime.utc(2026, 5, 27, 8),
        note: 'полил до поддона',
        clientId: 'uuid-1',
      );

      final request = draft.toRequest(CareEventType.spray);

      expect(request.plantId, 42);
      expect(request.type, CareEventType.spray);
      expect(request.note, 'полил до поддона');
      expect(request.clientId, 'uuid-1');
    });

    test('should_send_performedAt_as_UTC_even_when_draft_holds_local_time', () {
      // Источник — локальное время; в DTO обязан уйти UTC (toRequest .toUtc()).
      final local = DateTime(2026, 5, 27, 13, 30); // не-UTC (локаль процесса)
      final draft = draftWith(
        type: CareEventKind.water,
        performedAtUtc: local,
      );

      final request = draft.toRequest(CareEventType.water);

      expect(request.performedAt.isUtc, isTrue);
      expect(request.performedAt, local.toUtc());
    });

    test('should_keep_clientId_null_when_draft_has_none', () {
      final draft = draftWith(
        type: CareEventKind.water,
        performedAtUtc: DateTime.utc(2026, 5, 27),
      );

      final request = draft.toRequest(CareEventType.water);

      expect(request.clientId, isNull);
      expect(request.note, isNull);
    });
  });

  group('CareEventResponseMapper.toDomain', () {
    test('should_map_response_to_LoggedCareEvent_including_onTime', () {
      final response = CareEventResponse(
        id: 7,
        plantId: 42,
        plantName: 'Фикус',
        type: CareEventType.fertilize,
        performedAt: DateTime.utc(2026, 5, 27, 8),
        onTime: false,
        note: 'удобрил',
        clientId: 'uuid-1',
      );

      final logged = response.toDomain();

      expect(logged.id, 7);
      expect(logged.plantId, 42);
      expect(logged.plantName, 'Фикус');
      expect(logged.type, CareEventKind.fertilize);
      expect(logged.onTime, isFalse);
      expect(logged.note, 'удобрил');
      expect(logged.clientId, 'uuid-1');
    });

    test('should_normalize_performedAt_to_UTC', () {
      // Backend мог прислать не-UTC DateTime — toDomain нормализует в UTC.
      final response = CareEventResponse(
        id: 1,
        plantId: 42,
        plantName: 'x',
        type: CareEventType.water,
        performedAt: DateTime(2026, 5, 27, 23), // локальное
        onTime: true,
      );

      final logged = response.toDomain();

      expect(logged.performedAtUtc.isUtc, isTrue);
      expect(logged.performedAtUtc, DateTime(2026, 5, 27, 23).toUtc());
    });

    test('should_map_unparsed_backend_type_to_kind_unknown', () {
      final response = CareEventResponse(
        id: 1,
        plantId: 42,
        plantName: 'x',
        type: CareEventType.$unknown,
        performedAt: DateTime.utc(2026, 5, 27),
        onTime: true,
      );

      final logged = response.toDomain();

      expect(logged.type, CareEventKind.unknown);
    });
  });
}
