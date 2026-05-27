import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_type.dart';
import 'package:plantcare_mobile/features/plant_card/data/mappers/care_history_mapper.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

CareEventResponse _response({
  CareEventType type = CareEventType.water,
  bool onTime = true,
  String? note,
  DateTime? performedAt,
}) =>
    CareEventResponse(
      id: 7,
      plantId: 42,
      plantName: 'Monstera',
      type: type,
      performedAt: performedAt ?? DateTime.utc(2026, 5, 27, 8, 30),
      onTime: onTime,
      note: note,
    );

void main() {
  group('CareEventResponseMapper.toDomain', () {
    test('should_map_scalar_fields_when_response_given', () {
      final dto = _response(
        performedAt: DateTime.utc(2026, 5, 27, 8, 30),
        note: 'Полил утром',
      );

      final entry = dto.toDomain();

      expect(entry.id, 7);
      expect(entry.plantId, 42);
      expect(entry.plantName, 'Monstera');
      expect(entry.onTime, isTrue);
      expect(entry.note, 'Полил утром');
      expect(entry.performedAt, DateTime.utc(2026, 5, 27, 8, 30));
    });

    test('should_preserve_performedAt_as_utc_when_mapping', () {
      final dto = _response(performedAt: DateTime.utc(2026, 1, 1, 23, 15));

      final entry = dto.toDomain();

      expect(entry.performedAt, DateTime.utc(2026, 1, 1, 23, 15));
      expect(entry.performedAt.isUtc, isTrue);
    });

    test('should_keep_note_null_when_response_note_null', () {
      final dto = _response(note: null);

      final entry = dto.toDomain();

      expect(entry.note, isNull);
    });

    test('should_carry_onTime_false_when_response_late', () {
      final dto = _response(onTime: false);

      final entry = dto.toDomain();

      expect(entry.onTime, isFalse);
    });

    test('should_map_WATER_to_water_kind', () {
      final entry = _response(type: CareEventType.water).toDomain();

      expect(entry.kind, CareEventKind.water);
    });

    test('should_map_SPRAY_to_spray_kind', () {
      final entry = _response(type: CareEventType.spray).toDomain();

      expect(entry.kind, CareEventKind.spray);
    });

    test('should_map_FERTILIZE_to_fertilize_kind', () {
      final entry = _response(type: CareEventType.fertilize).toDomain();

      expect(entry.kind, CareEventKind.fertilize);
    });

    test('should_collapse_unknown_backend_type_to_unknown_kind', () {
      // Контракт мог добавить тип — десериализация даёт $unknown, не падаем.
      final entry = _response(type: CareEventType.$unknown).toDomain();

      expect(entry.kind, CareEventKind.unknown);
    });
  });
}
