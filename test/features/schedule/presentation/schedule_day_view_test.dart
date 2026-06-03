import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/schedule/presentation/schedule_day_view.dart';

CareTask _task({
  required int scheduleId,
  required DateTime dueAt,
  CareTaskType type = CareTaskType.watering,
}) =>
    CareTask(
      scheduleId: scheduleId,
      plantId: scheduleId,
      plantName: 'Plant $scheduleId',
      type: type,
      dueAt: dueAt,
    );

void main() {
  // Начало сегодняшнего дня (локальная полночь) для деривации просрочки.
  final startOfToday = DateTime(2026, 5, 20);

  group('buildScheduleDayView grouping', () {
    test('should_split_tasks_into_morning_and_evening_by_local_hour', () {
      // Используем local DateTime, чтобы тест не зависел от TZ хоста.
      final tasks = [
        _task(scheduleId: 1, dueAt: DateTime(2026, 5, 20, 9)), // утро
        _task(scheduleId: 2, dueAt: DateTime(2026, 5, 20, 19)), // вечер
      ];

      final view = buildScheduleDayView(
        tasks: tasks,
        startOfToday: startOfToday,
        doneKeys: const {},
      );

      expect(view.groups.length, 2);
      expect(view.groups[0].phase, ScheduleAgendaPhase.morning);
      expect(view.groups[1].phase, ScheduleAgendaPhase.evening);
      expect(view.totalCount, 2);
      expect(view.doneCount, 0);
    });

    test('should_sort_within_phase_by_dueAt', () {
      final tasks = [
        _task(scheduleId: 1, dueAt: DateTime(2026, 5, 20, 11)),
        _task(scheduleId: 2, dueAt: DateTime(2026, 5, 20, 8)),
      ];

      final view = buildScheduleDayView(
        tasks: tasks,
        startOfToday: startOfToday,
        doneKeys: const {},
      );

      final morning = view.groups.single.items;
      expect(morning.first.task.scheduleId, 2); // 8:00 раньше 11:00
      expect(morning.last.task.scheduleId, 1);
    });
  });

  group('buildScheduleDayView done', () {
    test('should_move_done_tasks_into_done_section_and_count_them', () {
      final tasks = [
        _task(scheduleId: 1, dueAt: DateTime(2026, 5, 20, 9)),
        _task(scheduleId: 2, dueAt: DateTime(2026, 5, 20, 19)),
      ];

      final view = buildScheduleDayView(
        tasks: tasks,
        startOfToday: startOfToday,
        doneKeys: const {1},
      );

      // Утренняя задача отмечена → ушла в «Сделано», осталась только вечерняя.
      expect(view.doneCount, 1);
      expect(view.totalCount, 2);
      final phases = view.groups.map((g) => g.phase).toList();
      expect(phases, contains(ScheduleAgendaPhase.evening));
      expect(phases, contains(ScheduleAgendaPhase.done));
      expect(phases, isNot(contains(ScheduleAgendaPhase.morning)));
      final done = view.groups
          .firstWhere((g) => g.phase == ScheduleAgendaPhase.done)
          .items
          .single;
      expect(done.done, isTrue);
      // Отмеченная задача не считается просроченной.
      expect(done.overdue, isFalse);
    });
  });

  group('buildScheduleDayView overdue', () {
    test('should_flag_task_before_start_of_today_as_overdue', () {
      final tasks = [
        // Дедлайн вчера утром → просрочено.
        _task(scheduleId: 1, dueAt: DateTime(2026, 5, 19, 9)),
      ];

      final view = buildScheduleDayView(
        tasks: tasks,
        startOfToday: startOfToday,
        doneKeys: const {},
      );

      expect(view.groups.single.items.single.overdue, isTrue);
    });
  });

  group('buildScheduleDayView empty', () {
    test('should_report_empty_when_no_tasks', () {
      final view = buildScheduleDayView(
        tasks: const [],
        startOfToday: startOfToday,
        doneKeys: const {},
      );

      expect(view.isEmpty, isTrue);
      expect(view.groups, isEmpty);
      expect(view.totalCount, 0);
    });
  });
}
