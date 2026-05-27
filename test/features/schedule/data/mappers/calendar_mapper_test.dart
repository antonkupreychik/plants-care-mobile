import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/calendar_response.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/features/schedule/data/mappers/calendar_mapper.dart';

TaskDto _dto({
  int scheduleId = 1,
  String plantName = 'Monstera',
  String taskType = 'WATERING',
  required DateTime nextDueAt,
}) =>
    TaskDto(
      scheduleId: scheduleId,
      plantId: scheduleId,
      plantName: plantName,
      taskType: taskType,
      nextDueAt: nextDueAt,
    );

void main() {
  // Понедельник 18 мая 2026.
  final weekStart = DateTime(2026, 5, 18);

  group('CalendarResponseMapper.toScheduleWeek structure', () {
    test('should_produce_exactly_seven_days_monday_to_sunday', () {
      final CalendarResponse response = {
        '2026-05-18': [_dto(nextDueAt: DateTime.utc(2026, 5, 18, 9))],
      };

      final week = response.toScheduleWeek(weekStart: weekStart);

      expect(week.days, hasLength(7));
      expect(week.weekStart, DateTime(2026, 5, 18));
      // Пн→Вс подряд, ровно по дню.
      expect(
        week.days.map((d) => d.date).toList(),
        [
          DateTime(2026, 5, 18),
          DateTime(2026, 5, 19),
          DateTime(2026, 5, 20),
          DateTime(2026, 5, 21),
          DateTime(2026, 5, 22),
          DateTime(2026, 5, 23),
          DateTime(2026, 5, 24),
        ],
      );
      expect(week.days.first.date.weekday, DateTime.monday);
      expect(week.days.last.date.weekday, DateTime.sunday);
    });

    test('should_fill_days_without_tasks_with_empty_list', () {
      // Сервер прислал задачи только на среду; остальные дни — дыры.
      final CalendarResponse response = {
        '2026-05-20': [_dto(nextDueAt: DateTime.utc(2026, 5, 20, 9))],
      };

      final week = response.toScheduleWeek(weekStart: weekStart);

      expect(week.days[2].tasks, hasLength(1)); // среда 20-е
      // Все прочие дни присутствуют, но пусты.
      final emptyDays = week.days.where((d) => d.tasks.isEmpty).toList();
      expect(emptyDays, hasLength(6));
    });

    test('should_return_seven_empty_days_when_response_empty', () {
      final week =
          (<String, List<TaskDto>>{}).toScheduleWeek(weekStart: weekStart);

      expect(week.days, hasLength(7));
      expect(week.days.every((d) => d.tasks.isEmpty), isTrue);
    });

    test('should_normalize_weekStart_to_date_only_midnight', () {
      // weekStart с временем → раскладка должна идти от полуночи.
      final week = (<String, List<TaskDto>>{})
          .toScheduleWeek(weekStart: DateTime(2026, 5, 18, 14, 37));

      expect(week.weekStart, DateTime(2026, 5, 18));
      expect(week.days.first.date, DateTime(2026, 5, 18));
    });
  });

  group('CalendarResponseMapper grouping by server key (not local TZ)', () {
    test('should_group_strictly_by_server_date_key_not_nextDueAt_toLocal', () {
      // Задача под серверным ключом среды (20-е), но nextDueAt в UTC — поздний
      // вечер 19-го, который в положительных TZ ушёл бы на 20-е, а в
      // отрицательных мог бы остаться на 19-е. Маппер обязан класть задачу
      // строго под серверный ключ '2026-05-20', независимо от .toLocal().
      final CalendarResponse response = {
        '2026-05-20': [_dto(nextDueAt: DateTime.utc(2026, 5, 19, 23, 30))],
      };

      final week = response.toScheduleWeek(weekStart: weekStart);

      final wednesday =
          week.days.firstWhere((d) => d.date == DateTime(2026, 5, 20));
      final tuesday =
          week.days.firstWhere((d) => d.date == DateTime(2026, 5, 19));
      expect(wednesday.tasks, hasLength(1));
      expect(tuesday.tasks, isEmpty);
    });

    test('should_keep_task_under_server_key_when_local_would_shift_forward',
        () {
      // nextDueAt = ранний UTC 21-го (00:30); в TZ < UTC локально это 20-е,
      // но серверный ключ — '2026-05-21'. Задача остаётся на 21-м.
      final CalendarResponse response = {
        '2026-05-21': [_dto(nextDueAt: DateTime.utc(2026, 5, 21, 0, 30))],
      };

      final week = response.toScheduleWeek(weekStart: weekStart);

      final thursday =
          week.days.firstWhere((d) => d.date == DateTime(2026, 5, 21));
      final wednesday =
          week.days.firstWhere((d) => d.date == DateTime(2026, 5, 20));
      expect(thursday.tasks, hasLength(1));
      expect(wednesday.tasks, isEmpty);
    });

    test('should_ignore_keys_outside_the_requested_week', () {
      // Ключи до и после недели не должны попасть в дни.
      final CalendarResponse response = {
        '2026-05-17': [_dto(nextDueAt: DateTime.utc(2026, 5, 17, 9))],
        '2026-05-25': [_dto(nextDueAt: DateTime.utc(2026, 5, 25, 9))],
        '2026-05-18': [_dto(nextDueAt: DateTime.utc(2026, 5, 18, 9))],
      };

      final week = response.toScheduleWeek(weekStart: weekStart);

      final total = week.days.fold<int>(0, (s, d) => s + d.tasks.length);
      expect(total, 1); // только 18-е внутри недели
      expect(week.days.first.tasks, hasLength(1));
    });

    test('should_preserve_backend_order_of_tasks_within_a_day', () {
      final CalendarResponse response = {
        '2026-05-18': [
          _dto(scheduleId: 10, nextDueAt: DateTime.utc(2026, 5, 18, 8)),
          _dto(scheduleId: 20, nextDueAt: DateTime.utc(2026, 5, 18, 18)),
        ],
      };

      final week = response.toScheduleWeek(weekStart: weekStart);

      expect(week.days.first.tasks.map((t) => t.scheduleId), [10, 20]);
    });
  });

  group('CalendarResponseMapper taskType normalization', () {
    test('should_map_known_task_types_to_domain_enum', () {
      final CalendarResponse response = {
        '2026-05-18': [
          _dto(scheduleId: 1, taskType: 'WATERING', nextDueAt: DateTime.utc(2026, 5, 18, 8)),
          _dto(scheduleId: 2, taskType: 'MISTING', nextDueAt: DateTime.utc(2026, 5, 18, 9)),
          _dto(scheduleId: 3, taskType: 'FERTILIZING', nextDueAt: DateTime.utc(2026, 5, 18, 10)),
          _dto(scheduleId: 4, taskType: 'SOIL_CHECK', nextDueAt: DateTime.utc(2026, 5, 18, 11)),
        ],
      };

      final tasks = response.toScheduleWeek(weekStart: weekStart).days.first.tasks;

      expect(tasks.map((t) => t.type), [
        CareTaskType.watering,
        CareTaskType.misting,
        CareTaskType.fertilizing,
        CareTaskType.soilCheck,
      ]);
    });

    test('should_map_unknown_task_type_to_unknown_without_throwing', () {
      final CalendarResponse response = {
        '2026-05-18': [
          _dto(taskType: 'PRUNING', nextDueAt: DateTime.utc(2026, 5, 18, 8)),
        ],
      };

      final tasks =
          response.toScheduleWeek(weekStart: weekStart).days.first.tasks;

      expect(tasks.single.type, CareTaskType.unknown);
    });

    test('should_carry_plantName_and_dueAt_through_mapping', () {
      final due = DateTime.utc(2026, 5, 18, 8);
      final CalendarResponse response = {
        '2026-05-18': [_dto(plantName: 'Фикус', nextDueAt: due)],
      };

      final task =
          response.toScheduleWeek(weekStart: weekStart).days.first.tasks.single;

      expect(task.plantName, 'Фикус');
      expect(task.dueAt, due);
    });
  });
}
