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
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/schedule/data/schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_day.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_repository.dart';
import 'package:plantcare_mobile/features/schedule/domain/schedule_week.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_providers.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_screen.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_agenda_row.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_day_selector.dart';
import 'package:plantcare_mobile/features/schedule/presentation/widgets/schedule_week_skeleton.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

class _MockRepo extends Mock implements ScheduleRepository {}

class _MockCareEventRepo extends Mock implements CareEventRepository {}

/// «Сегодня» — среда 20 мая 2026, полдень UTC. Понедельник этой недели = 18 мая.
final _nowUtc = DateTime.utc(2026, 5, 20, 12);
final _thisMonday = DateTime(2026, 5, 18);

Future<T> _pending<T>() => Completer<T>().future;

/// Неделя с задачами на среду (= сегодня): утренняя и вечерняя.
ScheduleWeek _weekWithTasks(DateTime monday) {
  return ScheduleWeek(
    weekStart: monday,
    days: List.generate(7, (i) {
      final date = DateTime(monday.year, monday.month, monday.day + i);
      if (i == 2) {
        return ScheduleDay(
          date: date,
          tasks: [
            // Утро (UTC 8:00 → час < 12 при большинстве реальных TZ хоста).
            CareTask(
              scheduleId: 1,
              plantId: 1,
              plantName: 'Моника',
              type: CareTaskType.misting,
              dueAt: DateTime.utc(2026, 5, 20, 8),
              speciesName: 'Монстера',
            ),
            // Вечер (UTC 17:00 → час >= 12).
            CareTask(
              scheduleId: 2,
              plantId: 2,
              plantName: 'Сьюзи',
              type: CareTaskType.watering,
              dueAt: DateTime.utc(2026, 5, 20, 17),
              speciesName: 'Суккулент',
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

Widget _wrap({
  ScheduleRepository? repo,
  CareEventRepository? careRepo,
  bool loadingThisWeek = false,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_nowUtc)),
      if (repo != null) scheduleRepositoryProvider.overrideWithValue(repo),
      if (careRepo != null)
        careEventRepositoryProvider.overrideWithValue(careRepo),
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
    registerFallbackValue(
      CareEventDraft(
        plantId: 0,
        type: CareEventKind.water,
        performedAtUtc: DateTime.utc(1970),
      ),
    );
    await initializeDateFormatting('ru');
  });

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(ScheduleScreen)));

  group('ScheduleScreen loading', () {
    testWidgets('should_show_week_skeleton_when_loading', (tester) async {
      await tester.pumpWidget(_wrap(loadingThisWeek: true));
      await tester.pump();

      expect(find.byType(ScheduleWeekSkeleton), findsOneWidget);
      // Header виден во всех состояниях.
      expect(find.text('График ухода'), findsOneWidget);
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

      final afterFirst = calls;
      await tester.tap(find.text(l10nOf(tester).retry));
      await tester.pumpAndSettle();

      expect(calls, greaterThan(afterFirst));
    });
  });

  group('ScheduleScreen data', () {
    testWidgets('should_render_day_selector_and_today_tasks_in_sections',
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
      // День-селектор отрисован.
      expect(find.byType(ScheduleDaySelector), findsOneWidget);
      // Сегодня (среда) выбрано по умолчанию → задачи дня видны строками.
      expect(find.byType(ScheduleAgendaRow), findsNWidgets(2));
      expect(find.text('Моника'), findsOneWidget);
      expect(find.text('Сьюзи'), findsOneWidget);
      // Секции утро/вечер.
      expect(
        find.text(l10n.schedulePhaseMorning.toUpperCase()),
        findsOneWidget,
      );
      expect(
        find.text(l10n.schedulePhaseEvening.toUpperCase()),
        findsOneWidget,
      );
      // Прогресс «0 из 2 готово».
      expect(find.text(l10n.scheduleDayProgress(0, 2)), findsOneWidget);
    });
  });

  group('ScheduleScreen empty day', () {
    testWidgets('should_show_empty_day_hint_when_selected_day_has_no_tasks',
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
      expect(find.text(l10n.scheduleDayEmpty), findsOneWidget);
      expect(find.byType(ScheduleAgendaRow), findsNothing);
      // Селектор по-прежнему доступен.
      expect(find.byType(ScheduleDaySelector), findsOneWidget);
    });
  });

  group('ScheduleScreen day selection', () {
    testWidgets('should_switch_to_empty_hint_when_free_day_tapped',
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
      expect(find.byType(ScheduleAgendaRow), findsNWidgets(2));
      expect(find.text(l10n.scheduleDayEmpty), findsNothing);

      // Тап по понедельнику (число «18», свободный день).
      await tester.tap(find.text('18'));
      await tester.pumpAndSettle();

      expect(find.byType(ScheduleAgendaRow), findsNothing);
      expect(find.text(l10n.scheduleDayEmpty), findsOneWidget);
    });
  });

  group('ScheduleScreen mark done', () {
    testWidgets('should_move_task_to_done_and_post_when_check_tapped',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _weekWithTasks(i.namedArguments[#weekStart] as DateTime),
        ),
      );
      final careRepo = _MockCareEventRepo();
      CareEventDraft? captured;
      when(() => careRepo.logCareEvent(any())).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as CareEventDraft;
        return Result.success(
          LoggedCareEvent(
            id: 10,
            plantId: captured!.plantId,
            plantName: 'Моника',
            type: captured!.type,
            performedAtUtc: _nowUtc,
            onTime: true,
          ),
        );
      });

      await tester.pumpWidget(_wrap(repo: repo, careRepo: careRepo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      // Тап по кнопке-чеку первой строки (утро · Моника).
      final firstCheck = find.descendant(
        of: find.byType(ScheduleAgendaRow).first,
        matching: find.byType(InkWell),
      );
      await tester.tap(firstCheck.first);
      await tester.pumpAndSettle();

      // POST ушёл с публичным типом spray (misting → spray) и clientId.
      expect(captured, isNotNull);
      expect(captured!.type, CareEventKind.spray);
      expect(captured!.clientId, isNotNull);
      // Появилась секция «Сделано», прогресс «1 из 2 готово».
      expect(
        find.text(l10n.schedulePhaseDone.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(l10n.scheduleDayProgress(1, 2)), findsOneWidget);
    });

    testWidgets('should_rollback_and_show_banner_when_post_fails',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.getWeek(weekStart: any(named: 'weekStart'))).thenAnswer(
        (i) async => Result.success(
          _weekWithTasks(i.namedArguments[#weekStart] as DateTime),
        ),
      );
      final careRepo = _MockCareEventRepo();
      when(() => careRepo.logCareEvent(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo: repo, careRepo: careRepo));
      await tester.pumpAndSettle();

      final l10n = l10nOf(tester);
      final firstCheck = find.descendant(
        of: find.byType(ScheduleAgendaRow).first,
        matching: find.byType(InkWell),
      );
      await tester.tap(firstCheck.first);
      await tester.pumpAndSettle();

      // Откат: секции «Сделано» нет, баннер ошибки показан, прогресс 0 из 2.
      expect(find.text(l10n.schedulePhaseDone.toUpperCase()), findsNothing);
      expect(find.text(l10n.scheduleMarkError), findsOneWidget);
      expect(find.text(l10n.scheduleDayProgress(0, 2)), findsOneWidget);
    });
  });
}
