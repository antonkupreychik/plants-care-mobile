import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/care/care_task_l10n.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';
import 'package:plantcare_mobile/l10n/app_localizations_ru.dart';

CareTask _task({required DateTime dueAt}) => CareTask(
      scheduleId: 1,
      plantId: 1,
      plantName: 'Monstera',
      type: CareTaskType.watering,
      dueAt: dueAt,
    );

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    // DateFormat.Hm('ru') требует инициализации символов локали.
    await initializeDateFormatting('ru');
  });

  setUp(() => l10n = AppLocalizationsRu());

  group('CareTaskL10n.dueLabel', () {
    test('should_return_overdue_when_due_is_before_now', () {
      // dueAt задаём в UTC; now — на час позже соответствующего локального времени.
      final dueUtc = DateTime.utc(2026, 5, 27, 8);
      final now = dueUtc.toLocal().add(const Duration(hours: 1));

      final label = _task(dueAt: dueUtc).dueLabel(l10n, now);

      expect(label, l10n.careDueOverdue);
    });

    test('should_return_due_at_time_when_due_is_after_now', () {
      final dueUtc = DateTime.utc(2026, 5, 27, 8);
      final now = dueUtc.toLocal().subtract(const Duration(hours: 2));

      final label = _task(dueAt: dueUtc).dueLabel(l10n, now);

      final expectedTime = DateFormat.Hm('ru').format(dueUtc.toLocal());
      expect(label, l10n.careDueAt(expectedTime));
    });

    // Таймзонная ловушка: метка форматируется по ЛОКАЛЬНОМУ времени (toLocal),
    // а не по UTC-часам. Если убрать .toLocal() в продакшене — на не-UTC машине
    // в метке будет другой час, и этот assert упадёт.
    test('should_format_time_in_local_timezone_not_utc', () {
      final dueUtc = DateTime.utc(2026, 5, 27, 8, 30);
      final now = dueUtc.toLocal().subtract(const Duration(hours: 1));

      final label = _task(dueAt: dueUtc).dueLabel(l10n, now);

      final local = dueUtc.toLocal();
      final expected = l10n.careDueAt(DateFormat.Hm('ru').format(local));
      expect(label, expected);

      // Если машина не в UTC — подтверждаем, что метка отличается от UTC-часов.
      if (local.timeZoneOffset != Duration.zero) {
        final utcLabel = l10n.careDueAt(DateFormat.Hm('ru').format(dueUtc));
        expect(label, isNot(utcLabel));
      }
    });

    test('should_use_overdue_boundary_at_exact_now_as_not_overdue', () {
      final dueUtc = DateTime.utc(2026, 5, 27, 8);
      final now = dueUtc.toLocal();

      final label = _task(dueAt: dueUtc).dueLabel(l10n, now);

      // isBefore(now) ложно при равенстве → не «просрочено».
      expect(label, isNot(l10n.careDueOverdue));
    });
  });
}
