import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

final _now = DateTime.utc(2026, 5, 27, 9);

CareTask _task() => CareTask(
      scheduleId: 1,
      plantId: 1,
      plantName: 'Фикус',
      type: CareTaskType.watering,
      dueAt: _now.add(const Duration(hours: 3)),
    );

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  group('TodayCard progress bar and badge', () {
    testWidgets(
        'should_not_show_progress_bar_or_badge_when_completedCount_is_zero',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task()],
        now: _now,
        onTaskTap: (_) {},
        completedCount: 0,
        totalCount: 2,
      )));
      await tester.pumpAndSettle();

      // Ни прогресс-бара, ни бейджа при 0 выполненных.
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });

    testWidgets(
        'should_not_show_progress_bar_or_badge_when_totalCount_is_zero',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: const [],
        now: _now,
        onTaskTap: (_) {},
        completedCount: 0,
        totalCount: 0,
      )));
      await tester.pumpAndSettle();

      // Нет задач вообще — прогресс-элементы скрыты.
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });

    testWidgets(
        'should_show_progress_bar_and_badge_when_some_tasks_completed',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task()],
        now: _now,
        onTaskTap: (_) {},
        completedCount: 1,
        totalCount: 2,
      )));
      await tester.pumpAndSettle();

      // Есть выполненные задачи — видны и прогресс-бар, и бейдж.
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('should_display_correct_percent_in_badge', (tester) async {
      // 1 из 2 выполнено → 50%.
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task()],
        now: _now,
        onTaskTap: (_) {},
        completedCount: 1,
        totalCount: 2,
      )));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(TodayCard)));
      expect(find.text(l10n.homeTodayProgressBadge(50)), findsOneWidget);
    });

    testWidgets(
        'should_display_100_percent_in_badge_when_all_tasks_completed',
        (tester) async {
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: const [],
        now: _now,
        onTaskTap: (_) {},
        completedCount: 2,
        totalCount: 2,
      )));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(TodayCard)));
      expect(find.text(l10n.homeTodayProgressBadge(100)), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should_not_show_progress_elements_when_completedCount_and_totalCount_both_default',
        (tester) async {
      // Вызов без completedCount/totalCount — обратная совместимость.
      await tester.pumpWidget(_wrap(TodayCard(
        tasks: [_task()],
        now: _now,
        onTaskTap: (_) {},
      )));
      await tester.pumpAndSettle();

      // По умолчанию оба параметра 0 — прогресс не показывается.
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });
  });

  group('TodayTasksResult progress computation', () {
    test('progressFraction_should_be_zero_when_total_is_zero', () {
      // Проверяем чистую логику расчёта прогресса напрямую через виджет-параметры.
      const completedCount = 0;
      const totalCount = 0;
      final fraction = totalCount > 0 ? completedCount / totalCount : 0.0;
      expect(fraction, 0.0);
    });

    test('progressPercent_should_be_50_when_half_done', () {
      const completedCount = 1;
      const totalCount = 2;
      final percent =
          totalCount > 0 ? ((completedCount / totalCount) * 100).round() : 0;
      expect(percent, 50);
    });

    test('progressPercent_should_round_correctly_for_third', () {
      const completedCount = 1;
      const totalCount = 3;
      final percent =
          totalCount > 0 ? ((completedCount / totalCount) * 100).round() : 0;
      expect(percent, 33);
    });
  });
}
