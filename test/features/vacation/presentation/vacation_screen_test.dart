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
import 'package:plantcare_mobile/features/vacation/data/vacation_repository_provider.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_range.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_repository.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_status.dart';
import 'package:plantcare_mobile/features/vacation/presentation/vacation_screen.dart';
import 'package:plantcare_mobile/features/vacation/presentation/widgets/vacation_active_banner.dart';
import 'package:plantcare_mobile/features/vacation/presentation/widgets/vacation_date_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements VacationRepository {}

class _FakeRange extends Fake implements VacationRange {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

final _nowUtc = DateTime.utc(2026, 6, 1, 10);

Future<T> _pending<T>() => Completer<T>().future;

Widget _wrap(VacationRepository repo) {
  return ProviderScope(
    overrides: [
      vacationRepositoryProvider.overrideWithValue(repo),
      clockProvider.overrideWithValue(_FixedClock(_nowUtc)),
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
        home: const VacationScreen(),
      );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(VacationScreen)));

void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUpAll(() => registerFallbackValue(_FakeRange()));

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('loading', () {
    testWidgets('should_show_skeleton_while_pending', (tester) async {
      when(() => repo.getStatus())
          .thenAnswer((_) => _pending<Result<VacationStatus>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(VacationDateCard), findsNothing);
    });
  });

  group('error', () {
    testWidgets('should_show_ErrorState_and_reload_on_retry', (tester) async {
      var calls = 0;
      when(() => repo.getStatus()).thenAnswer((_) async {
        calls++;
        return const Result.failure(ApiError.network());
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      final before = calls;

      await tester.tap(find.text(_l10n(tester).retry));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(calls, greaterThan(before));
    });
  });

  group('inactive', () {
    testWidgets('should_show_date_cards_and_enable_cta', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getStatus())
          .thenAnswer((_) async => Result.success(VacationStatus.inactive));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(VacationDateCard), findsNWidgets(2));
      expect(find.byType(VacationActiveBanner), findsNothing);
      expect(find.text(_l10n(tester).vacationEnableCta), findsOneWidget);
    });

    testWidgets('should_call_start_when_enable_tapped', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getStatus())
          .thenAnswer((_) async => Result.success(VacationStatus.inactive));
      when(() => repo.start(any())).thenAnswer(
        (_) async => Result.success(
          VacationStatus(active: true, pausedUntil: DateTime.utc(2026, 6, 14)),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text(_l10n(tester).vacationEnableCta));
      await tester.pumpAndSettle();

      verify(() => repo.start(any())).called(1);
      // После успеха перерисовка в активное состояние.
      expect(find.byType(VacationActiveBanner), findsOneWidget);
    });
  });

  group('active', () {
    testWidgets('should_show_active_banner_and_disable_cta', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getStatus()).thenAnswer(
        (_) async => Result.success(
          VacationStatus(
            active: true,
            pausedUntil: DateTime.utc(2026, 6, 14, 20, 59, 59),
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(VacationActiveBanner), findsOneWidget);
      expect(find.byType(VacationDateCard), findsNothing);
      expect(find.text(_l10n(tester).vacationDisableCta), findsOneWidget);
    });

    testWidgets('should_call_end_when_disable_tapped', (tester) async {
      _useLargeSurface(tester);
      when(() => repo.getStatus()).thenAnswer(
        (_) async => Result.success(
          VacationStatus(active: true, pausedUntil: DateTime.utc(2026, 6, 14)),
        ),
      );
      when(() => repo.end())
          .thenAnswer((_) async => Result.success(VacationStatus.inactive));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text(_l10n(tester).vacationDisableCta));
      await tester.pumpAndSettle();

      verify(() => repo.end()).called(1);
      expect(find.byType(VacationDateCard), findsNWidgets(2));
    });
  });
}
