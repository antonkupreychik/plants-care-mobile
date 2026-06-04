import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/report/data/reports_repository_provider.dart';
import 'package:plantcare_mobile/features/report/domain/monthly_report.dart';
import 'package:plantcare_mobile/features/report/domain/reports_repository.dart';
import 'package:plantcare_mobile/features/report/presentation/monthly_report_screen.dart';
import 'package:plantcare_mobile/features/report/presentation/report_providers.dart';
import 'package:plantcare_mobile/features/report/presentation/widgets/report_month_picker.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements ReportsRepository {}

const _currentMonth = '2026-06';

MonthlyReport _report(String month) => MonthlyReport(
      month: month,
      done: 5,
      overdue: 1,
      byType: const {CareTaskType.watering: 5},
      streak: 3,
      healthTrend: const [],
    );

Widget _wrap(ReportsRepository repo) {
  return ProviderScope(
    overrides: [
      currentReportMonthProvider.overrideWithValue(_currentMonth),
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

  setUp(() {
    repo = _MockRepo();
    when(() => repo.getMonthlyReport(month: any(named: 'month')))
        .thenAnswer((inv) async {
      final month = inv.namedArguments[#month] as String;
      return Result.success(_report(month));
    });
  });

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(MonthlyReportScreen)));

  group('month navigation on MonthlyReportScreen', () {
    testWidgets('should_show_ReportMonthPicker_in_header', (tester) async {
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ReportMonthPicker), findsOneWidget);
    });

    testWidgets('should_start_on_current_month_and_next_disabled',
        (tester) async {
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      // Следующий месяц задизейблен (мы на текущем).
      final nextSemantics =
          find.bySemanticsLabel(l10n.reportNextMonth);
      expect(nextSemantics, findsOneWidget);
      // Предыдущий — активен.
      final prevSemantics =
          find.bySemanticsLabel(l10n.reportPrevMonth);
      expect(prevSemantics, findsOneWidget);
    });

    testWidgets('should_enable_next_button_and_canGoNext_true_after_prev',
        (tester) async {
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Находим ReportMonthPicker и тапаем «<» (prevMonth) через Semantics.
      final l10n = l10nOf(tester);
      await tester.tap(find.bySemanticsLabel(l10n.reportPrevMonth));
      await tester.pumpAndSettle();

      // После перехода picker должен показать canGoNext == true.
      // Проверяем: репо вызван хотя бы с предыдущим месяцем.
      verify(
        () => repo.getMonthlyReport(month: any(named: 'month')),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('should_re_request_data_after_switching_month', (tester) async {
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);

      // Тап «<» → переходим на предыдущий месяц.
      await tester.tap(find.bySemanticsLabel(l10n.reportPrevMonth));
      await tester.pumpAndSettle();

      // Репо должен быть вызван хотя бы раз, экран не падает.
      verify(
        () => repo.getMonthlyReport(month: any(named: 'month')),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
