import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_range.dart';

void main() {
  group('days', () {
    test('should_be_1_when_from_equals_to', () {
      final r = VacationRange(
        from: DateTime(2026, 6, 1),
        to: DateTime(2026, 6, 1),
      );
      expect(r.days, 1);
    });

    test('should_count_both_bounds_inclusive', () {
      final r = VacationRange(
        from: DateTime(2026, 6, 1),
        to: DateTime(2026, 6, 14),
      );
      expect(r.days, 14);
    });

    test('should_ignore_time_component', () {
      final r = VacationRange(
        from: DateTime(2026, 6, 1, 23, 59),
        to: DateTime(2026, 6, 2, 0, 1),
      );
      // Календарно — 2 дня, несмотря на близкое время.
      expect(r.days, 2);
    });
  });

  group('isValid', () {
    test('should_be_true_for_single_day', () {
      final r = VacationRange(
        from: DateTime(2026, 6, 1),
        to: DateTime(2026, 6, 1),
      );
      expect(r.isValid, isTrue);
    });

    test('should_be_true_at_max_duration', () {
      final from = DateTime(2026, 6, 1);
      final r = VacationRange(
        from: from,
        to: from.add(const Duration(days: kVacationMaxDays - 1)),
      );
      expect(r.days, kVacationMaxDays);
      expect(r.isValid, isTrue);
    });

    test('should_be_false_beyond_max_duration', () {
      final from = DateTime(2026, 6, 1);
      final r = VacationRange(
        from: from,
        to: from.add(const Duration(days: kVacationMaxDays)),
      );
      expect(r.days, kVacationMaxDays + 1);
      expect(r.isValid, isFalse);
    });

    test('should_be_false_when_to_before_from', () {
      final r = VacationRange(
        from: DateTime(2026, 6, 10),
        to: DateTime(2026, 6, 1),
      );
      expect(r.isValid, isFalse);
    });
  });
}
