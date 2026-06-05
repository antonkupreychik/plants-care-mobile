import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';

void main() {
  group('PlantEventType.wireName', () {
    test('should_match_backend_enum_names', () {
      expect(PlantEventType.transplant.wireName, 'TRANSPLANT');
      expect(PlantEventType.soilChange.wireName, 'SOIL_CHANGE');
      expect(PlantEventType.pruning.wireName, 'PRUNING');
      expect(PlantEventType.pestTreatment.wireName, 'PEST_TREATMENT');
    });

    test('should_expose_exactly_four_types', () {
      expect(PlantEventType.values, hasLength(4));
    });
  });

  group('PlantEventType.fromWire', () {
    test('should_parse_known_wire_names', () {
      expect(PlantEventType.fromWire('TRANSPLANT'), PlantEventType.transplant);
      expect(PlantEventType.fromWire('SOIL_CHANGE'), PlantEventType.soilChange);
      expect(PlantEventType.fromWire('PRUNING'), PlantEventType.pruning);
      expect(
        PlantEventType.fromWire('PEST_TREATMENT'),
        PlantEventType.pestTreatment,
      );
    });

    test('should_return_null_for_unknown_or_null', () {
      expect(PlantEventType.fromWire('WATERING'), isNull);
      expect(PlantEventType.fromWire(''), isNull);
      expect(PlantEventType.fromWire(null), isNull);
    });
  });
}
