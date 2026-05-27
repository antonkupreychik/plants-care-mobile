import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/schedule/data/schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_day.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_repository.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_week.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_providers.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_screen.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_header.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_ics_card.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_task_card.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_week_skeleton.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

class _MockRepo extends Mock implements ScheduleRepository {}

/// «Сегодня» — среда 20 мая 2026, полдень UTC (чтобы .toLocal() остался 20-м
/// при любой реалистичной TZ хоста). Понедельник этой недели = 18 мая.
final _nowUtc = DateTime.utc(2026, 5, 20, 12);
final _thisMonday = DateTime(2026, 5, 18);

Future<T> _pending<T>() => Completer<T>().future;

/// Неделя c одной поливочной задачей в среду (= сегодня) + просроченная.
ScheduleWeek _weekWithTasks(DateTime monday) {
  return ScheduleWeek(
    weekStart: monday,
    days: List.generate(7, (i) {
      final date = DateTime(monday.year, monday.month, monday.day + i);
      // Задачи кладём на среду (offset 2 от понедельника = «сегодня»).
      if (i == 2) {
        return ScheduleDay(
          date: date,
          tasks: [
            CareTask(
              scheduleId: 1,
              plantId: 1,
              plantName: 'Монстера',
              type: CareTaskType.watering,
              dueAt: _nowUtc.add(const Duration(hours: 2)),
            ),
            CareTask(
              scheduleId: 2,
              plantId: 2,
              plantName: 'Фикус',
              type: CareTaskType.misting,
              // Просрочено: дедлайн раньше now.
              dueAt: _nowUtc.subtract(const Duration(hours: 3)),
            ),
          ],
        );
      }
      return ScheduleDay(date: date, tasks: const []);
    }),
  );
}

ScheduleWeek _emptyWeek(DateTime monday) => ScheduleWeek(
      weekStart: monday,
      days: List.generate(
        7,
        (i) => ScheduleDay(
          date: DateTime(monday.year, monday.month, monday.day + i),
          tasks: const [],
        ),
      ),
    );

/// [repo] — мок репозитория (data/error/empty/навигация идут через него);
/// [loadingThisWeek] — застрять в loading на текущей неделе (без репозитория).
Widget _wrap({
  ScheduleRepository? repo,
  bool loadingThisWeek = false,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_nowUtc)),
      if (repo != null) scheduleRepositoryProvider.overrideWithValue(repo),
      if (loadingThisWeek)
        scheduleWeekProvider(_thisMonday)
            .overrideWith((ref) => _pending<ScheduleWeek>()),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const ScheduleScreen(),
    ),
  );
}

void main() {
  setUpAll(() async {
    registerFallbackValue(DateTime(2026, 5, 18));
    await initializeDateFormatting('ru');
  });

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(ScheduleScreen)));

  group('ScheduleScreen loading', () {
    testWidgets('should_show_week_skeleton_when_loading', (tester) async {
      await tester.pumpWidget(_wrap(loadingThisWeek: true));
      await tester.pump();

      expect(find.byType(ScheduleWeekSkeleton), findsOneWidget);
      // Хедер виден во всех состояниях.
      expect(find.byType(ScheduleHeader), findsOneWidget);
    });
  });

  group('ScheduleScreen error', () {
    testWidgets('should_show_error_state_with_retry_when_provider_fails',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart')))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10nOf(tester).retry), findsOneWidget);
    });

    testWidgets('should_refetch_week_when_retry_tapped', (tester) async {
      final repo = _MockRepo();
      var calls = 0;
      when(() => repo.getWeek(weekStart: any(named: 'weekStart')))
          .thenAnswer((_) async {
        calls++;
        return const Result.failure(ApiError.network());
      });

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      // Первый заход уже дёрнул репозиторий хотя бы раз.
      expect(calls, greaterThanOrEqualTo(1));
      final afterFirst = calls;

      await tester.tap(find.text(l10nOf(tester).retry));
      await tester.pumpAndSettle();

      // Retry → invalidate → повторный fetch той же недели.
      expect(calls, greaterThan(afterFirst));
    });
  });

  group('ScheduleScreen data', () {
    testWidgets('should_render_week_with_tasks_and_today_expanded',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _weekWithTasks(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      // Заголовок «N забот в саду» (2 задачи).
      expect(find.text(l10n.scheduleWeekTasksCount(2)), findsOneWidget);
      // Сегодняшний день раскрыт → карточки задач видны с именем растения.
      expect(find.byType(ScheduleTaskCard), findsNWidgets(2));
      expect(find.text('Монстера'), findsOneWidget);
      expect(find.text('Фикус'), findsOneWidget);
      // Просроченная задача помечена меткой «Просрочено».
      expect(find.text(l10n.careDueOverdue), findsOneWidget);
    });
  });

  group('ScheduleScreen empty', () {
    testWidgets('should_show_free_week_hint_when_no_tasks', (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _emptyWeek(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      // Не голый экран: hero-текст «сад отдыхает» (zero-форма) виден.
      expect(find.text(l10n.scheduleWeekTasksCount(0)), findsOneWidget);
      // Нет ни одной карточки задачи.
      expect(find.byType(ScheduleTaskCard), findsNothing);
      // Листание доступно (хедер с кнопками на месте).
      expect(find.byType(ScheduleHeader), findsOneWidget);
    });
  });

  group('ScheduleScreen week navigation', () {
    testWidgets('should_load_next_week_when_next_button_tapped',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _emptyWeek(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.byTooltip(l10n.scheduleNextWeek));
      await tester.pumpAndSettle();

      // Следующая неделя = текущий понедельник + 7 дней.
      final nextMonday = DateTime(2026, 5, 25);
      verify(() => repo.getWeek(weekStart: nextMonday)).called(1);
    });

    testWidgets('should_load_previous_week_when_previous_button_tapped',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _emptyWeek(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      await tester.tap(find.byTooltip(l10n.schedulePreviousWeek));
      await tester.pumpAndSettle();

      final prevMonday = DateTime(2026, 5, 11);
      verify(() => repo.getWeek(weekStart: prevMonday)).called(1);
    });
  });

  group('ScheduleScreen .ics block', () {
    testWidgets('should_be_inert_and_show_snackbar_when_tapped',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _emptyWeek(i.namedArguments[#weekStart] as DateTime),
        ),
      );

      await tester.pumpWidget(_wrap(repo: repo));
      await tester.pumpAndSettle();

      // Блок .ics отрисован.
      expect(find.byType(ScheduleIcsCard), findsOneWidget);

      // Карточка внизу скролла — проматываем к ней перед тапом.
      await tester.ensureVisible(find.byType(ScheduleIcsCard));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ScheduleIcsCard));
      await tester.pump(); // показать snackbar

      final l10n = l10nOf(tester);
      // Инертный: показывает coming-soon, экран ScheduleScreen остался.
      expect(find.text(l10n.comingSoon), findsOneWidget);
      expect(find.byType(ScheduleScreen), findsOneWidget);
    });
  });
}
