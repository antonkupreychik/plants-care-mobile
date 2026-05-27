import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/today_filter.dart';
import 'package:plantcare_mobile/features/home/presentation/today_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/today_screen.dart';
import 'package:plantcare_mobile/features/home/presentation/today_view.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_filter_pills.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_task_card.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

class _MockCareEventRepo extends Mock implements CareEventRepository {}

/// Записывает каждый выбранный фильтр для verify в тестах пилюль.
class _RecordingFilter extends SelectedTodayFilter {
  final selections = <TodayFilter>[];
  @override
  TodayFilter build() => TodayFilter.all;
  @override
  void select(TodayFilter filter) {
    selections.add(filter);
    super.select(filter);
  }
}

Future<T> _pending<T>() => Completer<T>().future;

final _nowUtc = DateTime(2026, 5, 27, 12).toUtc();

/// UTC-дедлайн, попадающий на [localHour] в локальной TZ процесса.
DateTime _localDue(int localHour) => DateTime(2026, 5, 27, localHour).toUtc();

CareTask _task({
  required DateTime dueUtc,
  CareTaskType type = CareTaskType.watering,
  int scheduleId = 1,
  String plantName = 'Monstera',
}) =>
    CareTask(
      scheduleId: scheduleId,
      plantId: scheduleId,
      plantName: plantName,
      type: type,
      dueAt: dueUtc,
    );

Widget _wrap({
  required List<Override> overrides,
}) {
  return ProviderScope(
    // Гасим авто-ретрай Riverpod 3 — иначе error-состояние зациклит pumpAndSettle.
    retry: (_, _) => null,
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_nowUtc)),
      ...overrides,
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const TodayScreen(),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(TodayScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(
      CareEventDraft(
        plantId: 0,
        type: CareEventKind.water,
        performedAtUtc: DateTime.utc(2026),
      ),
    );
  });

  group('TodayScreen loading', () {
    testWidgets('should_show_skeletons_when_view_loading', (tester) async {
      await tester.pumpWidget(_wrap(overrides: [
        todayViewProvider.overrideWith((ref) => _pending<TodayView>()),
      ]));
      await tester.pump();

      expect(find.byType(TodayTaskCardSkeleton), findsWidgets);
    });
  });

  group('TodayScreen error', () {
    testWidgets('should_show_error_with_retry_button_when_view_fails',
        (tester) async {
      await tester.pumpWidget(_wrap(overrides: [
        todayViewProvider.overrideWith(
          (ref) async => throw const ApiError.network(),
        ),
      ]));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('should_refetch_homeTasks_when_retry_tapped', (tester) async {
      // Источник `homeTasksProvider` бросает → todayView в error. Тап по retry
      // зовёт `ref.invalidate(homeTasksProvider)` → провайдер строится заново.
      // Считаем сборки, чтобы доказать рефетч, а не просто наличие кнопки.
      // (Авто-ретрай Riverpod выключен в _wrap, поэтому счётчик детерминирован.)
      var calls = 0;

      await tester.pumpWidget(_wrap(overrides: [
        homeTasksProvider.overrideWith((ref) async {
          calls++;
          throw const ApiError.network();
        }),
      ]));
      await tester.pumpAndSettle();
      expect(find.byType(ErrorState), findsOneWidget);
      expect(calls, 1);

      await tester.tap(find.text(_l10n(tester).retry));
      await tester.pumpAndSettle();

      // Повторная сборка homeTasksProvider после invalidate.
      expect(calls, 2);
    });
  });

  group('TodayScreen empty', () {
    testWidgets('should_show_empty_all_text_and_pills_when_filter_all_empty',
        (tester) async {
      await tester.pumpWidget(_wrap(overrides: [
        todayViewProvider.overrideWith(
          (ref) async => buildTodayView(
            tasks: const [],
            nowLocal: _nowUtc.toLocal(),
            filter: TodayFilter.all,
          ),
        ),
      ]));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Пилюли и шапка видны даже при пустоте.
      expect(find.byType(TodayFilterPills), findsOneWidget);
      expect(find.text(l10n.todayEmptyAll), findsOneWidget);
      expect(find.text(l10n.todayEmptyFilter), findsNothing);
    });

    testWidgets('should_show_filter_empty_text_when_active_filter_empty',
        (tester) async {
      // Под фильтром fertilizing задач нет, но всего одна watering-задача есть.
      await tester.pumpWidget(_wrap(overrides: [
        todayViewProvider.overrideWith(
          (ref) async => buildTodayView(
            tasks: [_task(dueUtc: _localDue(8))],
            nowLocal: _nowUtc.toLocal(),
            filter: TodayFilter.fertilizing,
          ),
        ),
      ]));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.todayEmptyFilter), findsOneWidget);
      expect(find.text(l10n.todayEmptyAll), findsNothing);
    });
  });

  group('TodayScreen data', () {
    testWidgets('should_render_sections_cards_and_overdue_badge',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(overrides: [
        todayViewProvider.overrideWith(
          (ref) async => buildTodayView(
            tasks: [
              // Просрочена (8ч < now 12).
              _task(dueUtc: _localDue(8), scheduleId: 1, plantName: 'Фикус'),
              // Вечерняя, будущая.
              _task(dueUtc: _localDue(19), scheduleId: 2, plantName: 'Кактус'),
            ],
            nowLocal: _nowUtc.toLocal(),
            filter: TodayFilter.all,
          ),
        ),
      ]));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Обе фазы отрисованы.
      expect(find.text(l10n.todayPhaseMorning), findsOneWidget);
      expect(find.text(l10n.todayPhaseEvening), findsOneWidget);
      // Карточки задач с именами растений.
      expect(find.byType(TodayTaskCard), findsNWidgets(2));
      expect(find.text('Фикус'), findsOneWidget);
      expect(find.text('Кактус'), findsOneWidget);
      // Бейдж «просрочено» — только для просроченной (одна задача).
      expect(find.text(l10n.todayOverdueBadge), findsOneWidget);
      // Summary: всего 2, просрочена 1.
      expect(
        find.textContaining(l10n.todaySummaryOverdue(1)),
        findsOneWidget,
      );
    });
  });

  group('TodayScreen filter pills', () {
    testWidgets('should_call_select_when_pill_tapped', (tester) async {
      final filter = _RecordingFilter();

      await tester.pumpWidget(_wrap(overrides: [
        selectedTodayFilterProvider.overrideWith(() => filter),
        todayViewProvider.overrideWith(
          (ref) async => buildTodayView(
            tasks: [
              _task(dueUtc: _localDue(8), type: CareTaskType.watering),
              _task(
                  dueUtc: _localDue(9),
                  type: CareTaskType.fertilizing,
                  scheduleId: 2),
            ],
            nowLocal: _nowUtc.toLocal(),
            filter: TodayFilter.all,
          ),
        ),
      ]));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.tap(find.text(l10n.todayFilterWatering));
      await tester.pump();

      expect(filter.selections, [TodayFilter.watering]);
    });
  });

  group('TodayScreen task tap', () {
    testWidgets('should_open_care_event_sheet_when_task_tapped',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repo = _MockCareEventRepo();
      when(() => repo.logCareEvent(any())).thenAnswer(
        (_) async => Result.success(
          LoggedCareEvent(
            id: 1,
            plantId: 1,
            plantName: 'Фикус',
            type: CareEventKind.water,
            performedAtUtc: _nowUtc,
            onTime: true,
          ),
        ),
      );

      await tester.pumpWidget(_wrap(overrides: [
        careEventRepositoryProvider.overrideWithValue(repo),
        todayViewProvider.overrideWith(
          (ref) async => buildTodayView(
            tasks: [_task(dueUtc: _localDue(8), plantName: 'Фикус')],
            nowLocal: _nowUtc.toLocal(),
            filter: TodayFilter.all,
          ),
        ),
      ]));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.tap(find.byType(TodayTaskCard));
      await tester.pumpAndSettle();

      // Sheet 06 открыт: видна его шапка.
      expect(find.text(l10n.careSheetTitleFor('Фикус')), findsOneWidget);
      expect(find.text(l10n.careSheetTypeLabel.toUpperCase()), findsOneWidget);
    });
  });
}
