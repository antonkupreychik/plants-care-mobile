import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/features/report/presentation/report_providers.dart';

/// Фиксированные часы — возвращают заданный UTC-момент.
class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Текущий месяц: июнь 2026 (полдень UTC, чтобы TZ-сдвиг не менял месяц).
const _currentMonth = '2026-06';
final _juneUtc = DateTime.utc(2026, 6, 15, 12);

ProviderContainer _makeContainer({String? currentMonthOverride}) {
  final container = ProviderContainer(
    overrides: [
      if (currentMonthOverride != null)
        currentReportMonthProvider.overrideWithValue(currentMonthOverride)
      else
        clockProvider.overrideWithValue(_FixedClock(_juneUtc)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SelectedReportMonthNotifier', () {
    group('initial state', () {
      test('should_default_to_current_month', () {
        final container = _makeContainer();
        final month = container.read(selectedReportMonthProvider);
        expect(month, _currentMonth);
      });
    });

    group('prevMonth', () {
      test('should_go_to_previous_month', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        container.read(selectedReportMonthProvider.notifier).prevMonth();
        expect(container.read(selectedReportMonthProvider), '2026-05');
      });

      test('should_cross_year_boundary_correctly', () {
        final container = _makeContainer(currentMonthOverride: '2026-01');
        container.read(selectedReportMonthProvider.notifier).prevMonth();
        expect(container.read(selectedReportMonthProvider), '2025-12');
      });

      test('should_zero_pad_month_number', () {
        final container = _makeContainer(currentMonthOverride: '2026-11');
        container.read(selectedReportMonthProvider.notifier).prevMonth();
        expect(container.read(selectedReportMonthProvider), '2026-10');
      });

      test('should_not_go_back_more_than_12_months', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        final notifier = container.read(selectedReportMonthProvider.notifier);
        // Перейти 12 раз назад → должны быть на '2025-06'.
        for (var i = 0; i < 12; i++) {
          notifier.prevMonth();
        }
        expect(container.read(selectedReportMonthProvider), '2025-06');
        // 13-й — не должен изменить состояние.
        notifier.prevMonth();
        expect(container.read(selectedReportMonthProvider), '2025-06');
      });
    });

    group('nextMonth', () {
      test('should_go_to_next_month', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        final notifier = container.read(selectedReportMonthProvider.notifier);
        notifier.prevMonth(); // переходим на '2026-05'
        notifier.nextMonth(); // возвращаемся на '2026-06'
        expect(container.read(selectedReportMonthProvider), _currentMonth);
      });

      test('should_not_go_beyond_current_month', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        container.read(selectedReportMonthProvider.notifier).nextMonth();
        // Состояние не должно поменяться — уже на текущем.
        expect(container.read(selectedReportMonthProvider), _currentMonth);
      });

      test('should_cross_year_boundary_forward', () {
        final container = _makeContainer(currentMonthOverride: '2026-02');
        final notifier = container.read(selectedReportMonthProvider.notifier);
        notifier.prevMonth(); // → '2026-01'
        notifier.prevMonth(); // → '2025-12'
        notifier.nextMonth(); // → '2026-01'
        expect(container.read(selectedReportMonthProvider), '2026-01');
      });
    });

    group('canGoPrev', () {
      test('should_be_true_when_on_current_month', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        final notifier = container.read(selectedReportMonthProvider.notifier);
        expect(notifier.canGoPrev, isTrue);
      });

      test('should_be_false_when_at_limit_of_12_months_back', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        final notifier = container.read(selectedReportMonthProvider.notifier);
        for (var i = 0; i < 12; i++) {
          notifier.prevMonth();
        }
        expect(notifier.canGoPrev, isFalse);
      });
    });

    group('canGoNext', () {
      test('should_be_false_when_on_current_month', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        final notifier = container.read(selectedReportMonthProvider.notifier);
        expect(notifier.canGoNext, isFalse);
      });

      test('should_be_true_when_one_month_back', () {
        final container = _makeContainer(currentMonthOverride: _currentMonth);
        final notifier = container.read(selectedReportMonthProvider.notifier);
        notifier.prevMonth();
        expect(notifier.canGoNext, isTrue);
      });
    });
  });
}
