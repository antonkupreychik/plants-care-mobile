import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/care_event/data/mappers/task_type_mapper.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
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

  // Обратное направление (G7, экран 33): публичный [CareEventKind] записанного
  // ухода → внутренний [CareTaskType] расписания, чтобы найти его nextDueAt.
  // Покрываем ВСЕ ветки: смена одного сопоставления (напр. spray → watering)
  // обязана уронить тест.
  group('careTaskTypeFromCareEventKind', () {
    test('should_map_water_to_watering', () {
      expect(
        careTaskTypeFromCareEventKind(CareEventKind.water),
        CareTaskType.watering,
      );
    });

    test('should_map_spray_to_misting', () {
      expect(
        careTaskTypeFromCareEventKind(CareEventKind.spray),
        CareTaskType.misting,
      );
    });

    test('should_map_fertilize_to_fertilizing', () {
      expect(
        careTaskTypeFromCareEventKind(CareEventKind.fertilize),
        CareTaskType.fertilizing,
      );
    });

    test('should_map_unknown_to_unknown_because_no_internal_equivalent', () {
      expect(
        careTaskTypeFromCareEventKind(CareEventKind.unknown),
        CareTaskType.unknown,
      );
    });

    test('should_cover_every_CareEventKind_branch', () {
      // Полнота: новый kind без ветки уронит этот тест.
      for (final kind in CareEventKind.values) {
        expect(
          () => careTaskTypeFromCareEventKind(kind),
          returnsNormally,
          reason: 'нет ветки маппинга для $kind',
        );
      }
    });

    // Round-trip для трёх публичных типов: kind → taskType → kind стабилен.
    // soilCheck/unknown в эту сторону не входят (нет публичного эквивалента),
    // поэтому проверяем только публичную тройку.
    test('should_roundtrip_public_kinds_back_to_self', () {
      for (final kind in const [
        CareEventKind.water,
        CareEventKind.spray,
        CareEventKind.fertilize,
      ]) {
        expect(
          careEventKindFromTaskType(careTaskTypeFromCareEventKind(kind)),
          kind,
          reason: 'round-trip $kind нарушен',
        );
      }
    });
  });
}
