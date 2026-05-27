import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';

void main() {
  group('CareTaskType.fromApi', () {
    test('should_map_WATERING_to_watering', () {
      expect(CareTaskType.fromApi('WATERING'), CareTaskType.watering);
    });

    test('should_map_MISTING_to_misting', () {
      expect(CareTaskType.fromApi('MISTING'), CareTaskType.misting);
    });

    test('should_map_FERTILIZING_to_fertilizing', () {
      expect(CareTaskType.fromApi('FERTILIZING'), CareTaskType.fertilizing);
    });

    test('should_map_SOIL_CHECK_to_soilCheck', () {
      expect(CareTaskType.fromApi('SOIL_CHECK'), CareTaskType.soilCheck);
    });

    test('should_normalize_lowercase_input_to_uppercase_match', () {
      expect(CareTaskType.fromApi('watering'), CareTaskType.watering);
    });

    // Ловушка G7: контракт мог добавить новый тип — не падаем, рисуем нейтрально.
    test('should_return_unknown_when_code_is_not_recognized', () {
      expect(CareTaskType.fromApi('PRUNING'), CareTaskType.unknown);
    });

    test('should_return_unknown_when_input_is_garbage', () {
      expect(CareTaskType.fromApi('!@#%'), CareTaskType.unknown);
    });

    test('should_return_unknown_when_input_is_empty', () {
      expect(CareTaskType.fromApi(''), CareTaskType.unknown);
    });
  });
}
