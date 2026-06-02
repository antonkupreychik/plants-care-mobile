import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_locale.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_controller.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_state.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/timezone_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

UserSettings _settings({String timezone = 'Europe/Moscow'}) => UserSettings(
      quietHoursStart: const QuietTime(hour: 22, minute: 0),
      quietHoursEnd: const QuietTime(hour: 8, minute: 0),
      timezone: timezone,
      locale: UserLocale.ru,
    );

/// Spy-контроллер: фиксирует setTimezone/save, держит выбранную таймзону в
/// draft (через [draftTimezone]). Не ходит в сеть.
class _SpyController extends QuietHoursController {
  _SpyController({this.draftTimezone = 'Europe/Moscow', this.saveError});

  final String draftTimezone;
  final ApiError? saveError;
  final List<String> setTimezoneCalls = [];
  int saveCalls = 0;

  @override
  Future<QuietHoursState> build() async => QuietHoursState(
        loaded: _settings(timezone: draftTimezone),
        draft: _settings(timezone: draftTimezone),
      );

  @override
  void setTimezone(String iana) => setTimezoneCalls.add(iana);

  @override
  Future<ApiError?> save() async {
    saveCalls++;
    return saveError;
  }
}

Future<void> _pump(WidgetTester tester, _SpyController spy) async {
  final router = GoRouter(
    initialLocation: '/profile/timezone',
    routes: [
      GoRoute(
        path: '/profile/timezone',
        builder: (_, _) => const TimezoneScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, _) => const Scaffold(body: Text('profile-route')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        quietHoursControllerProvider.overrideWith(() => spy),
      ],
      child: MaterialApp.router(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('should_list_known_timezones', (tester) async {
    await _pump(tester, _SpyController());

    // Курируемый список (Москва, Калининград, …) отрисован.
    expect(find.text('Москва'), findsOneWidget);
    expect(find.text('Калининград'), findsOneWidget);
    expect(find.text('Екатеринбург'), findsOneWidget);
  });

  testWidgets('should_mark_selected_timezone_matching_draft', (tester) async {
    // draft.timezone = Asia/Yekaterinburg → галочка у Екатеринбурга.
    await _pump(tester, _SpyController(draftTimezone: 'Asia/Yekaterinburg'));

    // Ровно одна галочка (✓) на весь список — у выбранной строки.
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Каждая плитка обёрнута своим Semantics(label: city). Галочка живёт внутри
    // плитки Екатеринбурга и отсутствует в плитке Москвы.
    final yekaterinburgTile = find.ancestor(
      of: find.text('Екатеринбург'),
      matching: find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Екатеринбург',
      ),
    );
    expect(
      find.descendant(
        of: yekaterinburgTile,
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsOneWidget,
    );

    final moscowTile = find.ancestor(
      of: find.text('Москва'),
      matching: find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Москва',
      ),
    );
    expect(
      find.descendant(
        of: moscowTile,
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsNothing,
    );
  });

  testWidgets('should_filter_list_by_search_query', (tester) async {
    await _pump(tester, _SpyController());

    // Вводим «екат» → остаётся только Екатеринбург.
    await tester.enterText(find.byType(TextField), 'екат');
    await tester.pumpAndSettle();

    expect(find.text('Екатеринбург'), findsOneWidget);
    expect(find.text('Москва'), findsNothing);
    expect(find.text('Калининград'), findsNothing);
  });

  testWidgets('should_call_setTimezone_and_save_when_tile_tapped',
      (tester) async {
    final spy = _SpyController();
    await _pump(tester, spy);

    // Тап по «Екатеринбург» → setTimezone(IANA) + save().
    await tester.tap(find.text('Екатеринбург'));
    await tester.pumpAndSettle();

    expect(spy.setTimezoneCalls, ['Asia/Yekaterinburg']);
    expect(spy.saveCalls, 1);
  });

  testWidgets('should_show_snackbar_and_stay_when_save_fails', (tester) async {
    // Невалидная зона → backend 400: остаёмся на экране, снэкбар.
    final spy = _SpyController(saveError: const ApiError.badRequest());
    await _pump(tester, spy);

    await tester.tap(find.text('Владивосток'));
    await tester.pumpAndSettle();

    expect(spy.setTimezoneCalls, ['Asia/Vladivostok']);
    expect(spy.saveCalls, 1);
    expect(find.byType(TimezoneScreen), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
