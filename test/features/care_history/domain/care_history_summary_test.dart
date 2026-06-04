import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_summary.dart';

void main() {
  group('CareHistorySummary.onTimePercent', () {
    test('should_be_zero_when_no_entries_loaded', () {
      const summary = CareHistorySummary(
        total: 7,
        onTimeCount: 0,
        loadedCount: 0,
        streakCount: 0,
      );

      // loadedCount == 0 → 0 (не делим на ноль), даже если total > 0.
      expect(summary.onTimePercent, 0);
    });

    test('should_be_full_percent_when_all_loaded_on_time', () {
      const summary = CareHistorySummary(
        total: 4,
        onTimeCount: 4,
        loadedCount: 4,
        streakCount: 4,
      );

      expect(summary.onTimePercent, 100);
    });

    test('should_round_to_nearest_integer', () {
      // 2 / 3 = 66.66% → round → 67.
      const summary = CareHistorySummary(
        total: 3,
        onTimeCount: 2,
        loadedCount: 3,
        streakCount: 0,
      );

      expect(summary.onTimePercent, 67);
    });

    test('should_compute_over_loaded_not_total_when_pagination_incomplete', () {
      // G29: процент считается по ЗАГРУЖЕННЫМ (loadedCount), не по total.
      // 1 из 2 загруженных вовремя → 50%, хотя всего записей 100.
      const summary = CareHistorySummary(
        total: 100,
        onTimeCount: 1,
        loadedCount: 2,
        streakCount: 0,
      );

      expect(summary.onTimePercent, 50);
    });
  });
}
