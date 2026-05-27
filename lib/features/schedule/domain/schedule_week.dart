import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_day.dart';

part 'schedule_week.freezed.dart';

/// Недельный график ухода (экран 11): ровно 7 дней Пн→Вс.
///
/// Чистый Dart-контейнер. [weekStart] — понедельник недели (локальная полночь).
/// [days] — ровно 7 элементов в порядке Пн→Вс; дни без задач присутствуют с
/// пустым `tasks` (сборку «7 дней с дырами» делает data-маппер, см.
/// `CalendarResponseMapper`, чтобы domain оставался без логики).
@freezed
abstract class ScheduleWeek with _$ScheduleWeek {
  const factory ScheduleWeek({
    /// Понедельник недели (локальная полночь) — совпадает с `days.first.date`.
    required DateTime weekStart,

    /// Ровно 7 дней, Пн→Вс. Дни без задач = `ScheduleDay` с пустым `tasks`.
    required List<ScheduleDay> days,
  }) = _ScheduleWeek;
}
