import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_page_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_event_type.dart'
    as dto;
import 'package:plantcare_mobile/features/plant_events/data/mappers/plant_event_mapper.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';

PlantEventDto _dto(int id, dto.PlantEventType type) => PlantEventDto(
      id: id,
      eventType: type,
      eventDate: DateTime.utc(2026, 6, 1, 9),
    );

void main() {
  group('plantEventTypeFromDto (DTO enum → domain by wireName)', () {
    test('should_map_known_types_by_wireName', () {
      expect(
        plantEventTypeFromDto(dto.PlantEventType.transplant),
        PlantEventType.transplant,
      );
      expect(
        plantEventTypeFromDto(dto.PlantEventType.soilChange),
        PlantEventType.soilChange,
      );
      expect(
        plantEventTypeFromDto(dto.PlantEventType.pruning),
        PlantEventType.pruning,
      );
      expect(
        plantEventTypeFromDto(dto.PlantEventType.pestTreatment),
        PlantEventType.pestTreatment,
      );
    });

    test('should_return_null_for_unknown_dto_type', () {
      expect(plantEventTypeFromDto(dto.PlantEventType.$unknown), isNull);
    });
  });

  group('plantEventTypeToDto (domain → DTO enum)', () {
    test('should_round_trip_through_wireName', () {
      for (final type in PlantEventType.values) {
        expect(plantEventTypeFromDto(plantEventTypeToDto(type)), type);
      }
    });
  });

  group('PlantEventDtoMapper.toDomainOrNull', () {
    test('should_map_dto_fields_and_normalize_date_to_utc', () {
      final domain = PlantEventDto(
        id: 5,
        eventType: dto.PlantEventType.pruning,
        eventDate: DateTime.utc(2026, 5, 20, 12),
        comment: 'обрезал',
      ).toDomainOrNull();

      expect(domain, isNotNull);
      expect(domain!.id, 5);
      expect(domain.eventType, PlantEventType.pruning);
      expect(domain.comment, 'обрезал');
      expect(domain.eventDate.isUtc, isTrue);
    });

    test('should_return_null_for_unknown_type', () {
      expect(_dto(1, dto.PlantEventType.$unknown).toDomainOrNull(), isNull);
    });
  });

  group('PlantEventPageResponseMapper.toDomain', () {
    test('should_skip_unknown_typed_items_but_keep_total', () {
      final page = PlantEventPageResponse(
        items: [
          _dto(2, dto.PlantEventType.transplant),
          _dto(1, dto.PlantEventType.$unknown),
        ],
        total: 2,
        limit: 20,
        offset: 0,
      ).toDomain();

      expect(page.items, hasLength(1));
      expect(page.items.single.eventType, PlantEventType.transplant);
      expect(page.total, 2);
      expect(page.limit, 20);
      expect(page.offset, 0);
    });
  });
}
