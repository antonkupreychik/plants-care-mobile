import '../../../../core/api/generated/models/calendar_response.dart';
import '../../../../core/care/task_mapper.dart';
import '../../domain/schedule_day.dart';
import '../../domain/schedule_week.dart';

/// Маппинг ответа `/calendar` ([CalendarResponse] = `Map<String, List<TaskDto>>`)
/// в доменный [ScheduleWeek] (MADR-002).
///
/// Сборка «ровно 7 дней Пн→Вс с пустыми днями» — детерминированная структурная
/// раскладка из серверных данных и [weekStart], без бизнес-логики и без чтения
/// текущего времени, поэтому живёт в data-маппере (domain остаётся чистым
/// контейнером).
///
/// ВАЖНО: задачи группируются по серверным ключам-датам (`YYYY-MM-DD`) —
/// авторитетной дате дедлайна, — а НЕ по `nextDueAt.toLocal()`. Перегруппировка
/// по UTC могла бы сдвинуть задачу на соседний день.
extension CalendarResponseMapper on CalendarResponse {
  /// [weekStart] — понедельник недели (используются только его y/m/d).
  ScheduleWeek toScheduleWeek({required DateTime weekStart}) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);

    final days = List<ScheduleDay>.generate(
      7,
      (offset) {
        final date = DateTime(start.year, start.month, start.day + offset);
        final tasks = this[_dateKey(date)]
                ?.map((dto) => dto.toDomain())
                .toList(growable: false) ??
            const [];
        return ScheduleDay(date: date, tasks: tasks);
      },
      growable: false,
    );

    return ScheduleWeek(weekStart: start, days: days);
  }
}

/// Серверный ключ даты `YYYY-MM-DD` для локальной даты (date-only).
String _dateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
