import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/seasonal/data/seasonal_settings_repository_provider.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_mode.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_settings.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_settings_repository.dart';
import 'package:plantcare_mobile/features/seasonal/presentation/seasonal_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements SeasonalSettingsRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

SeasonalSettings _settings({
  bool enabled = false,
  SeasonalMode mode = SeasonalMode.multiplier,
}) =>
    SeasonalSettings(enabled: enabled, mode: mode);

Future<T> _pending<T>() => Completer<T>().future;

// Лето (июль) — детерминированный сезон для подсветки.
final _summerUtc = DateTime.utc(2026, 7, 1, 9);

Widget _wrap(SeasonalSettingsRepository repo) {
  return ProviderScope(
    overrides: [
      seasonalSettingsRepositoryProvider.overrideWithValue(repo),
      clockProvider.overrideWithValue(_FixedClock(_summerUtc)),
    ],
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
        home: const SeasonalScreen(),
      );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(SeasonalScreen)));

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
          .thenAnswer((_) => _pending<Result<SeasonalSettings>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(Switch), findsNothing);
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
      final before = calls;

      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(calls, greaterThan(before));
    });
  });

  group('data', () {
    testWidgets('should_render_toggle_on_and_current_summer_card',
        (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings(enabled: true)));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final toggle = tester.widget<Switch>(find.byType(Switch));
      expect(toggle.value, isTrue);
      // Карточка текущего сезона показывает лето (по FixedClock).
      expect(
        find.text(l10n.seasonalNowLabel(l10n.seasonalSummer).toUpperCase()),
        findsOneWidget,
      );
      // Включённое состояние → текст подстройки, не off-вариант.
      expect(find.text(l10n.seasonalCardOnTitle), findsOneWidget);
      expect(find.text(l10n.seasonalCardOffTitle), findsNothing);
    });

    testWidgets('should_render_off_card_when_disabled', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings(enabled: false)));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final toggle = tester.widget<Switch>(find.byType(Switch));
      expect(toggle.value, isFalse);
      expect(find.text(l10n.seasonalCardOffTitle), findsOneWidget);
    });

    testWidgets('should_call_setEnabled_when_toggled', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings(enabled: false)));
      when(() => repo.setEnabled(true))
          .thenAnswer((_) async => Result.success(_settings(enabled: true)));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      verify(() => repo.setEnabled(true)).called(1);
    });

    testWidgets('should_show_snackbar_on_toggle_failure', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getSettings())
          .thenAnswer((_) async => Result.success(_settings(enabled: false)));
      when(() => repo.setEnabled(true))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      // Тумблер откатился в выключенное состояние.
      final toggle = tester.widget<Switch>(find.byType(Switch));
      expect(toggle.value, isFalse);
    });
  });
}
