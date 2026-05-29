import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/report/data/reports_repository_provider.dart';
import 'package:plantcare_mobile/features/report/domain/monthly_report.dart';
import 'package:plantcare_mobile/features/report/domain/reports_repository.dart';
import 'package:plantcare_mobile/features/report/domain/weekly_health_bucket.dart';
import 'package:plantcare_mobile/features/report/presentation/monthly_report_screen.dart';
import 'package:plantcare_mobile/features/report/presentation/report_providers.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_big_numbers.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_by_type.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_empty.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_loading.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_share_cta.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_weekly_trend.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements ReportsRepository {}

const _month = '2026-05';

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

final _fullReport = MonthlyReport(
  month: _month,
  done: 17,
  overdue: 4,
  byType: const {
    CareTaskType.watering: 9,
    CareTaskType.fertilizing: 8,
  },
  streak: 12,
  healthTrend: const [
    WeeklyHealthBucket(week: '2026-W18', done: 8, onTimePct: 1),
    WeeklyHealthBucket(week: '2026-W19', done: 9, onTimePct: 0.6),
  ],
);

final _emptyReport = MonthlyReport(
  month: _month,
  done: 0,
  overdue: 0,
  byType: const {},
  streak: 0,
  healthTrend: const [],
);

Widget _wrap(ReportsRepository repo) {
  return ProviderScope(
    overrides: [
      currentReportMonthProvider.overrideWithValue(_month),
      reportsRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const MonthlyReportScreen(),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(MonthlyReportScreen)));

  group('loading', () {
    testWidgets('should_show_ReportLoading_skeleton_while_pending',
        (tester) async {
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) => _pending<Result<MonthlyReport>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(ReportLoading), findsOneWidget);
      // В loading нет ни данных, ни empty-карточки.
      expect(find.byType(ReportBigNumbers), findsNothing);
      expect(find.byType(ReportEmpty), findsNothing);
    });
  });

  group('error', () {
    testWidgets('should_show_ErrorState_with_retry_and_not_crash_on_tap',
        (tester) async {
      var calls = 0;
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) async {
        calls++;
        return const Result.failure(ApiError.network());
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      final callsBefore = calls;

      // Retry инвалидирует провайдер → повторный запрос; экран не падает.
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(calls, greaterThan(callsBefore));
      expect(find.byType(ErrorState), findsOneWidget);
    });
  });

  group('empty', () {
    testWidgets('should_show_ReportEmpty_and_no_big_numbers_when_isEmpty',
        (tester) async {
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) async => Result.success(_emptyReport));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ReportEmpty), findsOneWidget);
      // Empty-состояние не рисует крупные числа/тренд/CTA.
      expect(find.byType(ReportBigNumbers), findsNothing);
      expect(find.byType(ReportWeeklyTrend), findsNothing);
      expect(find.byType(ReportShareCta), findsNothing);
    });
  });

  group('data', () {
    testWidgets('should_render_numbers_type_chips_and_weekly_trend',
        (tester) async {
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) async => Result.success(_fullReport));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Крупные числа в зоне видимости сразу: стрик (12), done (17), overdue (4).
      expect(find.byType(ReportBigNumbers), findsOneWidget);
      expect(find.text('12'), findsWidgets);
      expect(find.text('17'), findsWidgets);
      expect(find.text('4'), findsWidgets);

      final l10n = l10nOf(tester);
      final listView = find.byType(Scrollable).first;

      // ReportByType ниже по списку (ListView ленив) — прокручиваем к нему.
      await tester.scrollUntilVisible(find.byType(ReportByType), 300,
          scrollable: listView);
      expect(find.byType(ReportByType), findsOneWidget);
      // Чипы типов: счётчики 9 и 8 (watering / fertilizing).
      expect(find.text('9'), findsWidgets);
      expect(find.text('8'), findsWidgets);

      // Недельный тренд с номерами недель из ReportFormat (18, 19).
      await tester.scrollUntilVisible(find.byType(ReportWeeklyTrend), 300,
          scrollable: listView);
      expect(find.byType(ReportWeeklyTrend), findsOneWidget);
      expect(find.text(l10n.reportWeekLabel('18')), findsOneWidget);
      expect(find.text(l10n.reportWeekLabel('19')), findsOneWidget);
    });

    testWidgets('should_show_comingSoon_snackbar_when_share_cta_tapped',
        (tester) async {
      when(() => repo.getMonthlyReport(month: any(named: 'month')))
          .thenAnswer((_) async => Result.success(_fullReport));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      // Нижняя CTA — в конце ленивого ListView; прокручиваем к ней и тапаем.
      await tester.scrollUntilVisible(
        find.byType(ReportShareCta),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ReportShareCta));
      await tester.pump(); // запускаем анимацию SnackBar

      expect(tester.takeException(), isNull);
      expect(find.text(l10n.comingSoon), findsOneWidget);
    });
  });
}
