import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/care_event/data/mappers/task_type_mapper.dart';
import 'package:plantcare_mobile/features/home/domain/care_task_type.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';

/// Маппер-ловушка (BACKEND-GAPS G7): внутренний [CareTaskType] из `/today`
/// нормализуется в публичный [CareEventKind] для `POST /care-events`. Покрываем
/// ВСЕ ветки switch — если кто-то поменяет одно сопоставление (напр. misting →
/// water), тест обязан упасть.
void main() {
  group('careEventKindFromTaskType', () {
    test('should_map_watering_to_water', () {
      expect(
        careEventKindFromTaskType(CareTaskType.watering),
        CareEventKind.water,
      );
    });

    test('should_map_misting_to_spray', () {
      expect(
        careEventKindFromTaskType(CareTaskType.misting),
        CareEventKind.spray,
      );
    });

    test('should_map_fertilizing_to_fertilize', () {
      expect(
        careEventKindFromTaskType(CareTaskType.fertilizing),
        CareEventKind.fertilize,
      );
    });

    test('should_map_soilCheck_to_unknown_because_REST_has_no_equivalent', () {
      expect(
        careEventKindFromTaskType(CareTaskType.soilCheck),
        CareEventKind.unknown,
      );
    });

    test('should_map_unknown_to_unknown', () {
      expect(
        careEventKindFromTaskType(CareTaskType.unknown),
        CareEventKind.unknown,
      );
    });

    test('should_cover_every_CareTaskType_branch', () {
      // Гарантия полноты: если в enum добавят новый тип без ветки в мапперах,
      // этот тест укажет, что один из вариантов остался непокрытым выше.
      for (final type in CareTaskType.values) {
        expect(
          () => careEventKindFromTaskType(type),
          returnsNormally,
          reason: 'нет ветки маппинга для $type',
        );
      }
    });
  });
}
