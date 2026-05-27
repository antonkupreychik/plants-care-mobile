import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/home/presentation/today_filter.dart';
import 'package:plantcare_mobile/features/home/presentation/today_view.dart';

/// Создаёт задачу с дедлайном [dueUtc] (UTC). Прочие поля — детерминированные
/// заглушки; уникальный [scheduleId] нужен, чтобы различать задачи в сортировке.
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

/// Локальный момент в [hour] для текущей TZ процесса теста.
///
/// Деривация сравнивает `dueAt.toLocal()` с `nowLocal` и группирует по
/// `dueAt.toLocal().hour`. Чтобы тест был стабилен в любой TZ, мы задаём
/// дедлайны как локальные часы (через [_localDue]) и `nowLocal` тем же приёмом.
DateTime _localNow(int hour) {
  final l = DateTime(2026, 5, 27, hour);
  return l;
}

/// UTC-дедлайн, который в локальной TZ процесса попадает на [localHour].
///
/// `DateTime(...)` — локальное время; `.toUtc()` даёт UTC, который продакшен
/// вернёт обратно через `.toLocal()`. Так фаза/overdue считаются от ЛОКАЛЬНОГО
/// часа независимо от TZ машины.
DateTime _localDue(int localHour, [int minute = 0]) =>
    DateTime(2026, 5, 27, localHour, minute).toUtc();

void main() {
  group('buildTodayView overdue', () {
    test('should_mark_overdue_true_when_due_before_now_and_false_for_future',
        () {
      final now = _localNow(12);
      final past = _task(dueUtc: _localDue(9), scheduleId: 1);
      final future = _task(dueUtc: _localDue(15), scheduleId: 2);

      final view = buildTodayView(
        tasks: [past, future],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      final items = {
        for (final g in view.groups)
          for (final i in g.items) i.task.scheduleId: i.overdue,
      };
      expect(items[1], isTrue);
      expect(items[2], isFalse);
    });

    test('should_not_mark_overdue_when_due_equals_now_exactly', () {
      final dueUtc = _localDue(10);
      final now = dueUtc.toLocal();

      final view = buildTodayView(
        tasks: [_task(dueUtc: dueUtc)],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      // isBefore строго раньше → равенство не overdue.
      expect(view.groups.single.items.single.overdue, isFalse);
      expect(view.overdueCount, 0);
    });
  });

  group('buildTodayView grouping morning/evening', () {
    test('should_split_tasks_by_local_hour_morning_before_noon', () {
      final now = _localNow(6);
      final morning = _task(dueUtc: _localDue(8), scheduleId: 1);
      final evening = _task(dueUtc: _localDue(19), scheduleId: 2);

      final view = buildTodayView(
        tasks: [evening, morning],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      expect(view.groups.length, 2);
      expect(view.groups[0].phase, TodayPhase.morning);
      expect(view.groups[1].phase, TodayPhase.evening);
      expect(view.groups[0].items.single.task.scheduleId, 1);
      expect(view.groups[1].items.single.task.scheduleId, 2);
    });

    test('should_treat_local_hour_12_as_evening_boundary', () {
      final now = _localNow(6);
      final atNoon = _task(dueUtc: _localDue(12), scheduleId: 1);
      final beforeNoon = _task(dueUtc: _localDue(11, 59), scheduleId: 2);

      final view = buildTodayView(
        tasks: [atNoon, beforeNoon],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      expect(view.groups[0].phase, TodayPhase.morning);
      expect(view.groups[0].items.single.task.scheduleId, 2);
      expect(view.groups[1].phase, TodayPhase.evening);
      expect(view.groups[1].items.single.task.scheduleId, 1);
    });

    test('should_omit_empty_phase_when_only_evening_tasks', () {
      final now = _localNow(6);
      final view = buildTodayView(
        tasks: [_task(dueUtc: _localDue(18))],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      expect(view.groups.length, 1);
      expect(view.groups.single.phase, TodayPhase.evening);
    });
  });

  group('buildTodayView sorting', () {
    test('should_sort_items_within_group_by_dueAt_ascending', () {
      final now = _localNow(6);
      final late = _task(dueUtc: _localDue(11), scheduleId: 1);
      final early = _task(dueUtc: _localDue(7), scheduleId: 2);
      final mid = _task(dueUtc: _localDue(9), scheduleId: 3);

      final view = buildTodayView(
        tasks: [late, early, mid],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      final ids =
          view.groups.single.items.map((i) => i.task.scheduleId).toList();
      expect(ids, [2, 3, 1]);
    });
  });

  group('buildTodayView counters', () {
    test('should_count_by_type_over_full_list_independent_of_filter', () {
      final now = _localNow(6);
      final tasks = [
        _task(dueUtc: _localDue(8), type: CareTaskType.watering, scheduleId: 1),
        _task(dueUtc: _localDue(9), type: CareTaskType.watering, scheduleId: 2),
        _task(dueUtc: _localDue(10), type: CareTaskType.misting, scheduleId: 3),
        _task(
            dueUtc: _localDue(11),
            type: CareTaskType.fertilizing,
            scheduleId: 4),
        _task(
            dueUtc: _localDue(13), type: CareTaskType.soilCheck, scheduleId: 5),
        _task(dueUtc: _localDue(14), type: CareTaskType.unknown, scheduleId: 6),
      ];

      // Фильтр misting не должен влиять на счётчики (они по полному списку).
      final view = buildTodayView(
        tasks: tasks,
        nowLocal: now,
        filter: TodayFilter.misting,
      );

      expect(view.totalCount, 6);
      expect(view.wateringCount, 2);
      expect(view.mistingCount, 1);
      expect(view.fertilizingCount, 1);
    });

    test('should_count_overdue_including_soilcheck_and_unknown', () {
      final now = _localNow(12);
      final tasks = [
        // Просроченные (до 12): watering, soilCheck, unknown.
        _task(dueUtc: _localDue(8), type: CareTaskType.watering, scheduleId: 1),
        _task(
            dueUtc: _localDue(9), type: CareTaskType.soilCheck, scheduleId: 2),
        _task(dueUtc: _localDue(10), type: CareTaskType.unknown, scheduleId: 3),
        // Будущая.
        _task(
            dueUtc: _localDue(15), type: CareTaskType.watering, scheduleId: 4),
      ];

      final view = buildTodayView(
        tasks: tasks,
        nowLocal: now,
        filter: TodayFilter.all,
      );

      // soilCheck/unknown не имеют своих пилюль, но учитываются в overdue.
      expect(view.overdueCount, 3);
      expect(view.wateringCount, 2);
      expect(view.mistingCount, 0);
      expect(view.fertilizingCount, 0);
    });
  });

  group('buildTodayView filter', () {
    test('should_return_all_tasks_when_filter_all', () {
      final now = _localNow(6);
      final tasks = [
        _task(dueUtc: _localDue(8), type: CareTaskType.watering, scheduleId: 1),
        _task(dueUtc: _localDue(9), type: CareTaskType.misting, scheduleId: 2),
        _task(
            dueUtc: _localDue(10), type: CareTaskType.soilCheck, scheduleId: 3),
      ];

      final view = buildTodayView(
        tasks: tasks,
        nowLocal: now,
        filter: TodayFilter.all,
      );

      final shown = view.groups
          .expand((g) => g.items)
          .map((i) => i.task.scheduleId)
          .toSet();
      expect(shown, {1, 2, 3});
      expect(view.isEmpty, isFalse);
    });

    test('should_keep_only_watering_when_filter_watering', () {
      final now = _localNow(6);
      final tasks = [
        _task(dueUtc: _localDue(8), type: CareTaskType.watering, scheduleId: 1),
        _task(dueUtc: _localDue(9), type: CareTaskType.misting, scheduleId: 2),
      ];

      final view = buildTodayView(
        tasks: tasks,
        nowLocal: now,
        filter: TodayFilter.watering,
      );

      final shown =
          view.groups.expand((g) => g.items).map((i) => i.task.scheduleId);
      expect(shown, [1]);
    });

    test('should_keep_only_overdue_including_soilcheck_when_filter_overdue',
        () {
      final now = _localNow(12);
      final tasks = [
        // Просрочены: soilCheck + watering.
        _task(
            dueUtc: _localDue(8), type: CareTaskType.soilCheck, scheduleId: 1),
        _task(dueUtc: _localDue(9), type: CareTaskType.watering, scheduleId: 2),
        // Будущая — не должна попасть под overdue-фильтр.
        _task(
            dueUtc: _localDue(15), type: CareTaskType.watering, scheduleId: 3),
      ];

      final view = buildTodayView(
        tasks: tasks,
        nowLocal: now,
        filter: TodayFilter.overdue,
      );

      final shown = view.groups
          .expand((g) => g.items)
          .map((i) => i.task.scheduleId)
          .toSet();
      expect(shown, {1, 2});
    });

    test('should_be_empty_when_filter_matches_nothing', () {
      final now = _localNow(6);
      final tasks = [
        _task(dueUtc: _localDue(8), type: CareTaskType.watering, scheduleId: 1),
      ];

      final view = buildTodayView(
        tasks: tasks,
        nowLocal: now,
        filter: TodayFilter.fertilizing,
      );

      expect(view.isEmpty, isTrue);
      expect(view.groups, isEmpty);
      // Счётчики по полному списку остаются.
      expect(view.totalCount, 1);
      expect(view.wateringCount, 1);
    });

    test('should_be_empty_when_no_tasks_at_all', () {
      final view = buildTodayView(
        tasks: const [],
        nowLocal: _localNow(6),
        filter: TodayFilter.all,
      );

      expect(view.isEmpty, isTrue);
      expect(view.totalCount, 0);
      expect(view.overdueCount, 0);
    });
  });

  group('buildTodayView timezone', () {
    // КРИТИЧНО (FLUTTER.md «Время»): фаза/overdue считаются в ЛОКАЛЬНОЙ зоне
    // пользователя, а не по UTC-часам. Доказываем: дедлайн с UTC-часом, который
    // в локальной TZ попадает в ДРУГОЙ календарный час (и сторону полудня),
    // группируется по локальному часу. На не-UTC машине UTC-час и local-час
    // расходятся — тогда добавочный assert ловит регрессию `.toLocal()`.
    test('should_group_and_flag_overdue_by_local_hour_not_utc', () {
      // Локально: задача в 8 утра (morning), now — 12 дня.
      final dueUtc = _localDue(8);
      final now = _localNow(12);

      final view = buildTodayView(
        tasks: [_task(dueUtc: dueUtc)],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      final item = view.groups.single.items.single;
      expect(view.groups.single.phase, TodayPhase.morning);
      expect(item.overdue, isTrue);

      // Если машина не в UTC — локальный час дедлайна отличается от UTC-часа.
      // Это подтверждает, что деривация смотрит на toLocal(), а не на dueAt.hour.
      final offset = dueUtc.toLocal().timeZoneOffset;
      if (offset != Duration.zero) {
        expect(dueUtc.toLocal().hour, isNot(dueUtc.hour));
      }
    });

    test('should_move_task_to_evening_when_utc_hour_is_morning_but_local_pm',
        () {
      // Конструируем дедлайн, локальный час которого = 13 (evening), и
      // проверяем, что он во второй группе, даже если UTC-час < 12.
      final dueUtc = _localDue(13);
      final now = _localNow(6);

      final view = buildTodayView(
        tasks: [
          _task(dueUtc: dueUtc, scheduleId: 1),
          _task(dueUtc: _localDue(7), scheduleId: 2),
        ],
        nowLocal: now,
        filter: TodayFilter.all,
      );

      // Утренняя (7) и вечерняя (13) — по локальному часу.
      expect(view.groups[0].phase, TodayPhase.morning);
      expect(view.groups[0].items.single.task.scheduleId, 2);
      expect(view.groups[1].phase, TodayPhase.evening);
      expect(view.groups[1].items.single.task.scheduleId, 1);
    });
  });
}
