import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/add_plant/domain/care_difficulty.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';

void main() {
  group('SpeciesSummary.carePlan', () {
    test('should_build_items_for_all_positive_intervals_in_fixed_order', () {
      const species = SpeciesSummary(
        id: 1,
        name: 'Фикус',
        wateringDays: 7,
        mistingDays: 3,
        fertilizingDays: 30,
        soilCheckDays: 14,
      );

      final plan = species.carePlan;

      expect(plan.map((i) => i.type).toList(), [
        CareTaskType.watering,
        CareTaskType.misting,
        CareTaskType.fertilizing,
        CareTaskType.soilCheck,
      ]);
      expect(plan.map((i) => i.everyDays).toList(), [7, 3, 30, 14]);
    });

    test('should_skip_null_intervals', () {
      const species = SpeciesSummary(
        id: 1,
        name: 'Фикус',
        wateringDays: 7,
        mistingDays: null,
        fertilizingDays: 30,
        soilCheckDays: null,
      );

      final plan = species.carePlan;

      expect(plan.map((i) => i.type).toList(), [
        CareTaskType.watering,
        CareTaskType.fertilizing,
      ]);
    });

    test('should_skip_non_positive_intervals', () {
      const species = SpeciesSummary(
        id: 1,
        name: 'Фикус',
        wateringDays: 0,
        mistingDays: -5,
        fertilizingDays: 30,
        soilCheckDays: 14,
      );

      final plan = species.carePlan;

      // 0 и -5 отсечены, остаются только положительные.
      expect(plan.map((i) => i.type).toList(), [
        CareTaskType.fertilizing,
        CareTaskType.soilCheck,
      ]);
    });

    test('should_be_empty_when_no_intervals', () {
      const species = SpeciesSummary(id: 1, name: 'Фикус');

      expect(species.carePlan, isEmpty);
    });

    test('should_be_unmodifiable', () {
      const species = SpeciesSummary(id: 1, name: 'Фикус', wateringDays: 7);

      expect(
        () => species.carePlan.add(species.carePlan.first),
        throwsUnsupportedError,
      );
    });
  });

  group('SpeciesSummary defaults', () {
    test('should_default_careDifficulty_to_unknown', () {
      const species = SpeciesSummary(id: 1, name: 'Фикус');

      expect(species.careDifficulty, CareDifficulty.unknown);
    });
  });
}
