import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_week_start_provider.dart';

/// Фиксированные «часы» — отдают заданный UTC-момент вместо реального времени.
class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

ProviderContainer _containerAt(DateTime nowUtc) {
  final container = ProviderContainer(
    overrides: [clockProvider.overrideWithValue(_FixedClock(nowUtc))],
  );
  addTearDown(container.dispose);
  return container;
}

/// Ожидаемый понедельник недели, содержащей [local] (та же формула, что в
/// прод-коде, но вычисленная независимо от него для честной проверки).
DateTime _expectedMonday(DateTime local) {
  final dateOnly = DateTime(local.year, local.month, local.day);
  return DateTime(
    dateOnly.year,
    dateOnly.month,
    dateOnly.day - (dateOnly.weekday - DateTime.monday),
  );
}

void main() {
  group('ScheduleWeekStart.build initial value', () {
    // Замечание по TZ: тест-окружение использует локаль хоста. Берём nowUtc в
    // полдень (12:00), чтобы typical TZ-сдвиги (±14ч в крайних случаях не
    // достигаются на CI/dev) не перенесли .toLocal() на соседнюю дату — тогда
    // ожидаемый локальный календарный день детерминирован. Цель теста — поймать
    // регрессию «считаем от DateTime.now() вместо clockProvider» и неверный
    // расчёт понедельника, а не воспроизвести конкретную зону.

    test('should_use_clockProvider_not_real_now', () {
      // nowUtc намеренно «исторический» — если код возьмёт DateTime.now(),
      // результат уедет на текущую неделю и assert упадёт.
      final nowUtc = DateTime.utc(2026, 5, 20, 12); // среда
      final container = _containerAt(nowUtc);

      final weekStart = container.read(scheduleWeekStartProvider);

      expect(weekStart, _expectedMonday(nowUtc.toLocal()));
      expect(weekStart.weekday, DateTime.monday);
      // Полночь.
      expect(weekStart.hour, 0);
      expect(weekStart.minute, 0);
    });

    test('should_return_monday_itself_when_today_is_monday', () {
      final nowUtc = DateTime.utc(2026, 5, 18, 12); // понедельник
      final container = _containerAt(nowUtc);

      final weekStart = container.read(scheduleWeekStartProvider);

      final local = nowUtc.toLocal();
      expect(weekStart, _expectedMonday(local));
      // Если сегодня понедельник, weekStart == сегодняшняя дата (полночь).
      if (local.weekday == DateTime.monday) {
        expect(weekStart, DateTime(local.year, local.month, local.day));
      }
    });

    test('should_return_current_week_monday_when_today_is_sunday', () {
      // Граничный кейс: воскресенье 24 мая 2026 → понедельник ТЕКУЩЕЙ недели =
      // 18 мая (6 дней назад), а НЕ следующий понедельник.
      final nowUtc = DateTime.utc(2026, 5, 24, 12); // воскресенье
      final container = _containerAt(nowUtc);

      final weekStart = container.read(scheduleWeekStartProvider);

      final local = nowUtc.toLocal();
      final expected = _expectedMonday(local);
      expect(weekStart, expected);
      expect(weekStart.weekday, DateTime.monday);
      // Понедельник не позже локального «сегодня» (текущая, не следующая неделя).
      expect(
        weekStart.isAfter(DateTime(local.year, local.month, local.day)),
        isFalse,
      );
      // И разрыв ровно 6 дней при воскресенье.
      if (local.weekday == DateTime.sunday) {
        expect(
          DateTime(local.year, local.month, local.day).difference(weekStart),
          const Duration(days: 6),
        );
      }
    });
  });

  group('ScheduleWeekStart navigation', () {
    test('should_shift_seven_days_forward_on_nextWeek', () {
      final container = _containerAt(DateTime.utc(2026, 5, 20, 12));
      final initial = container.read(scheduleWeekStartProvider);

      container.read(scheduleWeekStartProvider.notifier).nextWeek();

      final next = container.read(scheduleWeekStartProvider);
      expect(next.difference(initial), const Duration(days: 7));
      expect(next.weekday, DateTime.monday);
    });

    test('should_shift_seven_days_back_on_previousWeek', () {
      final container = _containerAt(DateTime.utc(2026, 5, 20, 12));
      final initial = container.read(scheduleWeekStartProvider);

      container.read(scheduleWeekStartProvider.notifier).previousWeek();

      final prev = container.read(scheduleWeekStartProvider);
      expect(initial.difference(prev), const Duration(days: 7));
      expect(prev.weekday, DateTime.monday);
    });

    test('should_return_to_current_monday_on_resetToCurrentWeek', () {
      final container = _containerAt(DateTime.utc(2026, 5, 20, 12));
      final notifier = container.read(scheduleWeekStartProvider.notifier);
      final current = container.read(scheduleWeekStartProvider);

      notifier.nextWeek();
      notifier.nextWeek();
      expect(container.read(scheduleWeekStartProvider), isNot(current));

      notifier.resetToCurrentWeek();

      expect(container.read(scheduleWeekStartProvider), current);
    });

    test('should_cross_month_boundary_correctly_on_previousWeek', () {
      // Понедельник 1 июня 2026 → −7 дней = 25 мая (через границу месяца).
      final container = _containerAt(DateTime.utc(2026, 6, 3, 12)); // среда
      final notifier = container.read(scheduleWeekStartProvider.notifier);
      final start = container.read(scheduleWeekStartProvider); // Пн 1 июня

      notifier.previousWeek();

      final prev = container.read(scheduleWeekStartProvider);
      expect(prev, DateTime(start.year, start.month, start.day - 7));
      expect(prev.weekday, DateTime.monday);
    });
  });
}
