import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/quiet_hours/data/user_settings_repository_provider.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_locale.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/user_settings_repository.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/quiet_hours_screen.dart';
import 'package:plantcare_mobile/features/quiet_hours/presentation/widgets/quiet_hours_ring.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements UserSettingsRepository {}

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

Future<T> _pending<T>() => Completer<T>().future;

/// Обёртка экрана с реальным контроллером поверх мок-репо.
Widget _wrap(UserSettingsRepository repo) {
  return ProviderScope(
    overrides: [userSettingsRepositoryProvider.overrideWithValue(repo)],
    child: const _App(),
  );
}

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const QuietHoursScreen(),
      );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(QuietHoursScreen)));

/// Высокая поверхность: data-экран — длинный ListView, на 800×600 карточки
/// тихих часов (Row со stretch) переполняют высоту в тесте.
void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('loading', () {
    testWidgets('should_show_skeleton_while_pending', (tester) async {
      when(() => repo.getSettings())
          .thenAnswer((_) => _pending<Result<UserSettings>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(QuietHoursRing), findsNothing);
      expect(find.byType(ErrorState), findsNothing);
    });
  });

  group('error', () {
    testWidgets('should_show_ErrorState_with_retry_and_reload_on_tap',
        (tester) async {
      var calls = 0;
      when(() => repo.getSettings()).thenAnswer((_) async {
        calls++;
        return const Result.failure(ApiError.network());
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      final before = calls;

      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(calls, greaterThan(before));
    });
  });

  group('data', () {
    testWidgets('should_render_ring_times_and_timezone', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Кольцо нарисовано.
      expect(find.byType(QuietHoursRing), findsOneWidget);
      // Карточки времени: «22:00» (start) и «08:00» (end).
      expect(find.text('22:00'), findsWidgets);
      expect(find.text('08:00'), findsWidgets);
      // Подписи карточек (виджет рендерит метку в верхнем регистре).
      expect(
        find.text(l10n.quietHoursStartLabel.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(l10n.quietHoursEndLabel.toUpperCase()), findsOneWidget);
      // Таймзона: Москва · GMT+3.
      expect(find.text(l10n.quietHoursTimezoneTitle), findsOneWidget);
      expect(
        find.text(l10n.quietHoursTimezoneValue('Москва', 'GMT+3')),
        findsOneWidget,
      );
    });

    testWidgets('should_open_time_picker_sheet_when_start_card_tapped',
        (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Тапаем карточку «Засыпаю в» → открывается sheet 36.
      await tester.tap(find.text(l10n.quietHoursStartLabel.toUpperCase()));
      await tester.pumpAndSettle();

      // Sheet 36 виден: кнопка «Готово» и заголовок старта.
      expect(find.text(l10n.timePickerDone), findsOneWidget);
      expect(find.text(l10n.timePickerStartTitle), findsWidgets);
    });

    testWidgets('should_render_dnd_and_digest_switch_disabled', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings()));

      // Тумблер «Не беспокоить ночью» — backend-gap, без записи (onChanged null).
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.onChanged, isNull);
      final l10n = _l10n(tester);
      // Дайджест — фиксированное декоративное время, без тапа.
      expect(find.text(l10n.quietHoursDigestTime), findsOneWidget);
    });
  });
}
