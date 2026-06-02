import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/quiet_hours/data/user_settings_repository_provider.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_locale.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings_repository.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_screen.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/timezone_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements UserSettingsRepository {}

class _FakeQuietTime extends Fake implements QuietTime {}

UserSettings _settings({
  QuietTime start = const QuietTime(hour: 22, minute: 0),
  QuietTime end = const QuietTime(hour: 8, minute: 0),
  String timezone = 'Europe/Moscow',
}) =>
    UserSettings(
      quietHoursStart: start,
      quietHoursEnd: end,
      timezone: timezone,
      locale: UserLocale.ru,
    );

Future<void> _pump(WidgetTester tester, UserSettingsRepository repo) async {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/profile/quiet-hours',
    routes: [
      GoRoute(
        path: '/profile/quiet-hours',
        builder: (_, _) => const QuietHoursScreen(),
      ),
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
        userSettingsRepositoryProvider.overrideWithValue(repo),
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

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(QuietHoursScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeQuietTime());
  });

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  testWidgets(
      'should_update_start_time_on_screen_after_picker_done',
      (tester) async {
    when(() => repo.getSettings())
        .thenAnswer((_) async => Result.success(_settings()));
    // Backend эхом возвращает сохранённое (start уехал на 00:00 — топ колеса).
    when(() => repo.updateQuietHours(
          start: any(named: 'start'),
          end: any(named: 'end'),
        )).thenAnswer((inv) async {
      final start = inv.namedArguments[#start] as QuietTime?;
      return Result.success(
        _settings(start: start ?? const QuietTime(hour: 22, minute: 0)),
      );
    });

    await _pump(tester, repo);

    final l10n = _l10n(tester);
    // Исходно карточка старта показывает 22:00.
    expect(find.text('22:00'), findsWidgets);

    // Открываем пикер 36 тапом по «Засыпаю в» (метка в верхнем регистре).
    await tester.tap(find.text(l10n.quietHoursStartLabel.toUpperCase()));
    await tester.pumpAndSettle();

    // Прокручиваем колесо часов к началу (00) — детерминированно через
    // его FixedExtentScrollController (drag по экстенту неустойчив).
    final hourWheel =
        tester.widget<ListWheelScrollView>(find.byType(ListWheelScrollView).first);
    (hourWheel.controller as FixedExtentScrollController).jumpToItem(0);
    await tester.pumpAndSettle();

    // Жмём «Готово» → setQuietStart + save + закрытие шита.
    await tester.tap(find.text(l10n.timePickerDone));
    await tester.pumpAndSettle();

    // PATCH ушёл, экран обновил карточку старта новым значением.
    verify(() => repo.updateQuietHours(
          start: any(named: 'start'),
          end: any(named: 'end'),
        )).called(1);
    expect(find.byType(QuietHoursScreen), findsOneWidget);
    // Старое 22:00 в карточке старта больше не единственное — появилось 00:00.
    expect(find.text('00:00'), findsWidgets);
  });

  testWidgets(
      'should_navigate_to_timezone_and_update_row_after_select',
      (tester) async {
    when(() => repo.getSettings())
        .thenAnswer((_) async => Result.success(_settings()));
    when(() => repo.updateTimezone(any())).thenAnswer(
      (inv) async => Result.success(
        _settings(timezone: inv.positionalArguments[0] as String),
      ),
    );

    await _pump(tester, repo);

    final l10n = _l10n(tester);
    // Исходно строка таймзоны — Москва · GMT+3.
    expect(
      find.text(l10n.quietHoursTimezoneValue('Москва', 'GMT+3')),
      findsOneWidget,
    );

    // Тап по строке «Таймзона» → push экрана 37.
    await tester.tap(find.text(l10n.quietHoursTimezoneTitle));
    await tester.pumpAndSettle();
    expect(find.byType(TimezoneScreen), findsOneWidget);

    // Выбираем Екатеринбург → setTimezone + save + pop назад на 23.
    await tester.tap(find.text('Екатеринбург'));
    await tester.pumpAndSettle();

    verify(() => repo.updateTimezone('Asia/Yekaterinburg')).called(1);
    // Вернулись на экран 23, строка таймзоны обновилась на Екатеринбург · GMT+5.
    expect(find.byType(QuietHoursScreen), findsOneWidget);
    expect(
      find.text(l10n.quietHoursTimezoneValue('Екатеринбург', 'GMT+5')),
      findsOneWidget,
    );
  });
}
