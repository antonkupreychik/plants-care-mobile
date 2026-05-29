import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/report/domain/monthly_report.dart';
import 'package:plantcare_mobile/features/report/domain/weekly_health_bucket.dart';

MonthlyReport _report({
  int done = 0,
  int overdue = 0,
  int streak = 0,
  Map<CareTaskType, int> byType = const {},
  List<WeeklyHealthBucket> healthTrend = const [],
}) =>
    MonthlyReport(
      month: '2026-05',
      done: done,
      overdue: overdue,
      byType: byType,
      streak: streak,
      healthTrend: healthTrend,
    );

void main() {
  group('MonthlyReport.onTimePct', () {
    test('should_weight_by_done_per_week_not_simple_average', () {
      // Неделя 1: done=10, 100% вовремя. Неделя 2: done=2, 0% вовремя.
      // Простое среднее дало бы (1.0 + 0.0) / 2 = 0.5.
      // Взвешенное: (10*1.0 + 2*0.0) / 12 = 0.8333… — именно его и ждём.
      final report = _report(
        done: 12,
        healthTrend: const [
          WeeklyHealthBucket(week: '2026-W18', done: 10, onTimePct: 1),
          WeeklyHealthBucket(week: '2026-W19', done: 2, onTimePct: 0),
        ],
      );

      final pct = report.onTimePct;

      expect(pct, isNotNull);
      expect(pct, closeTo(10 / 12, 1e-9));
      // Не равно простому среднему 0.5 — подтверждает именно взвешенность.
      expect(pct, isNot(closeTo(0.5, 1e-9)));
    });

    test('should_combine_three_weeks_with_different_weights', () {
      // (4*0.5 + 6*1.0 + 0*x) / 10 = 8/10 = 0.8. Нулевой done не влияет.
      final report = _report(
        done: 10,
        healthTrend: const [
          WeeklyHealthBucket(week: '2026-W18', done: 4, onTimePct: 0.5),
          WeeklyHealthBucket(week: '2026-W19', done: 6, onTimePct: 1),
          WeeklyHealthBucket(week: '2026-W20', done: 0, onTimePct: 0.3),
        ],
      );

      expect(report.onTimePct, closeTo(0.8, 1e-9));
    });

    test('should_be_null_when_healthTrend_empty', () {
      final report = _report(done: 5, healthTrend: const []);

      // Нет понедельных данных → процент посчитать не из чего.
      expect(report.onTimePct, isNull);
    });

    test('should_be_null_when_all_weeks_have_zero_done', () {
      final report = _report(
        healthTrend: const [
          WeeklyHealthBucket(week: '2026-W18', done: 0, onTimePct: 1),
          WeeklyHealthBucket(week: '2026-W19', done: 0, onTimePct: 0.5),
        ],
      );

      // sum(done) == 0 → null, несмотря на ненулевые onTimePct в неделях.
      expect(report.onTimePct, isNull);
    });
  });

  group('MonthlyReport.isEmpty', () {
    test('should_be_true_when_done_and_overdue_both_zero', () {
      final report = _report(done: 0, overdue: 0, streak: 7);

      // Стрик/byType не влияют — пустота определяется только done+overdue.
      expect(report.isEmpty, isTrue);
    });

    test('should_be_false_when_done_positive', () {
      expect(_report(done: 1, overdue: 0).isEmpty, isFalse);
    });

    test('should_be_false_when_overdue_positive', () {
      expect(_report(done: 0, overdue: 3).isEmpty, isFalse);
    });
  });
}
