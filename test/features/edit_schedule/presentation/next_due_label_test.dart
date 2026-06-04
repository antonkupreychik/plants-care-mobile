import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/next_due_label.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

  group('nextDueLabel relative formatting', () {
    test('should_return_null_when_nextDueAt_null', () {
      expect(nextDueLabel(l10n, null, DateTime(2026, 6, 1, 12)), isNull);
    });

    test('should_return_today_when_same_local_day', () {
      final now = DateTime(2026, 6, 1, 8);
      final due = DateTime(2026, 6, 1, 20).toUtc();

      expect(nextDueLabel(l10n, due, now), l10n.editScheduleDueToday);
    });

    test('should_return_tomorrow_when_next_local_day', () {
      final now = DateTime(2026, 6, 1, 8);
      final due = DateTime(2026, 6, 2, 8).toUtc();

      expect(nextDueLabel(l10n, due, now), l10n.editScheduleDueTomorrow);
    });

    test('should_return_in_N_days_when_several_days_ahead', () {
      final now = DateTime(2026, 6, 1, 8);
      final due = DateTime(2026, 6, 6, 8).toUtc();

      expect(nextDueLabel(l10n, due, now), l10n.editScheduleDueInDays(5));
    });

    test('should_return_overdue_when_local_day_in_past', () {
      final now = DateTime(2026, 6, 5, 8);
      final due = DateTime(2026, 6, 1, 8).toUtc();

      expect(nextDueLabel(l10n, due, now), l10n.editScheduleDueOverdue);
    });

    // Не-UTC таймзона: nextDueAt — UTC date-time у границы суток. Конструируем
    // момент так, чтобы UTC-календарный день и ЛОКАЛЬНЫЙ различались, независимо
    // от знака смещения хоста:
    //   - host восточнее UTC (offset > 0): 1 июня 23:30Z → локально уже 2 июня;
    //   - host западнее UTC (offset < 0): 2 июня 00:30Z → локально ещё 1 июня.
    // nowLocal фиксируем = 1 июня (локальный полдень). Метка обязана считаться
    // по ЛОКАЛЬНОЙ дате due: при сдвиге на «завтра» → tomorrow, иначе → today.
    // Регрессия «считаем по UTC-дню due» дала бы другой ответ.
    test('should_use_local_date_of_nextDueAt_under_nonUtc_tz', () {
      final offset = DateTime.now().timeZoneOffset;
      final nowLocal = DateTime(2026, 6, 1, 12); // локальный полдень 1 июня

      final DateTime dueUtc;
      final String expected;
      if (offset.isNegative) {
        // Западнее UTC: 2 июня 00:30Z → .toLocal() откатит на 1 июня (сегодня).
        dueUtc = DateTime.utc(2026, 6, 2, 0, 30);
        expected = l10n.editScheduleDueToday;
      } else {
        // Восточнее UTC: 1 июня 23:30Z → .toLocal() сдвинет на 2 июня (завтра).
        dueUtc = DateTime.utc(2026, 6, 1, 23, 30);
        expected = l10n.editScheduleDueTomorrow;
      }

      final dueLocalDay = dueUtc.toLocal().day;
      // Подтверждаем, что сдвиг действительно перевёл календарный день due
      // относительно его UTC-дня — иначе тест не проверял бы локаль.
      expect(dueLocalDay, isNot(dueUtc.day));

      expect(nextDueLabel(l10n, dueUtc, nowLocal), expected);
    }, skip: DateTime.now().timeZoneOffset == Duration.zero
        ? 'host TZ == UTC: сдвиг календарного дня воспроизвести нельзя'
        : false);
  });
}
