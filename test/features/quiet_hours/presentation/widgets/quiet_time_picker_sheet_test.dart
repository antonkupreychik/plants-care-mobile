import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_locale.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_controller.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_state.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/widgets/quiet_time_picker_sheet.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

UserSettings _settings() => const UserSettings(
      quietHoursStart: QuietTime(hour: 22, minute: 0),
      quietHoursEnd: QuietTime(hour: 8, minute: 0),
      timezone: 'Europe/Moscow',
      locale: UserLocale.ru,
    );

/// Spy-контроллер: фиксирует `setQuietStart/setQuietEnd` и факт `save()`,
/// не ходит в сеть. [saveError] — что вернуть из `save()`.
class _SpyController extends QuietHoursController {
  _SpyController({this.saveError});

  final ApiError? saveError;
  final List<QuietTime> startCalls = [];
  final List<QuietTime> endCalls = [];
  int saveCalls = 0;

  @override
  Future<QuietHoursState> build() async =>
      QuietHoursState(loaded: _settings(), draft: _settings());

  @override
  void setQuietStart(QuietTime start) => startCalls.add(start);

  @override
  void setQuietEnd(QuietTime end) => endCalls.add(end);

  @override
  Future<ApiError?> save() async {
    saveCalls++;
    return saveError;
  }
}

/// Хост, открывающий sheet 36 по кнопке (нужен реальный Navigator + контекст).
class _Host extends StatelessWidget {
  const _Host({required this.field});
  final QuietHoursField field;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showQuietTimePickerSheet(
              context,
              field: field,
              initial: const QuietTime(hour: 22, minute: 0),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }
}

Widget _wrap(_SpyController spy, {QuietHoursField field = QuietHoursField.start}) {
  return ProviderScope(
    overrides: [
      quietHoursControllerProvider.overrideWith(() => spy),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: _Host(field: field),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.text('open')));

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('should_render_two_wheels_and_done_button', (tester) async {
    final spy = _SpyController();

    await tester.pumpWidget(_wrap(spy));
    await tester.pumpAndSettle();
    await _openSheet(tester);

    final l10n = _l10n(tester);
    // Колёса часов и минут (CupertinoPicker), кнопка «Готово».
    expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    expect(find.text(l10n.timePickerDone), findsOneWidget);
  });

  testWidgets('should_call_setQuietStart_and_save_when_done_for_start_field',
      (tester) async {
    final spy = _SpyController();

    await tester.pumpWidget(_wrap(spy, field: QuietHoursField.start));
    await tester.pumpAndSettle();
    await _openSheet(tester);

    final l10n = _l10n(tester);
    await tester.tap(find.text(l10n.timePickerDone));
    await tester.pumpAndSettle();

    // «Готово» для поля start: setQuietStart(22:00) + save() ровно по разу.
    expect(spy.startCalls, [const QuietTime(hour: 22, minute: 0)]);
    expect(spy.endCalls, isEmpty);
    expect(spy.saveCalls, 1);
  });

  testWidgets('should_call_setQuietEnd_and_save_when_done_for_end_field',
      (tester) async {
    final spy = _SpyController();

    await tester.pumpWidget(_wrap(spy, field: QuietHoursField.end));
    await tester.pumpAndSettle();
    await _openSheet(tester);

    final l10n = _l10n(tester);
    await tester.tap(find.text(l10n.timePickerDone));
    await tester.pumpAndSettle();

    expect(spy.endCalls, [const QuietTime(hour: 22, minute: 0)]);
    expect(spy.startCalls, isEmpty);
    expect(spy.saveCalls, 1);
  });

  testWidgets('should_stay_open_and_show_snackbar_when_save_fails',
      (tester) async {
    // start == end → 400: остаёмся в шите, снэкбар.
    final spy = _SpyController(saveError: const ApiError.badRequest());

    await tester.pumpWidget(_wrap(spy, field: QuietHoursField.start));
    await tester.pumpAndSettle();
    await _openSheet(tester);

    final l10n = _l10n(tester);
    await tester.tap(find.text(l10n.timePickerDone));
    await tester.pumpAndSettle();

    expect(spy.saveCalls, 1);
    // Шит не закрыт (кнопка «Готово» ещё на экране), показан снэкбар.
    expect(find.text(l10n.timePickerDone), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
