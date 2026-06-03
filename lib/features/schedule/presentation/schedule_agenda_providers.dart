import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/care/care_task.dart';
import '../../../core/clock/clock_provider.dart';
import '../domain/schedule_day.dart';
import 'schedule_day_view.dart';
import 'schedule_mark_controller.dart';
import 'schedule_providers.dart';
import 'schedule_week_start_provider.dart';
import 'selected_schedule_day_provider.dart';

part 'schedule_agenda_providers.g.dart';

/// Список задач выбранного дня (для день-селектора и тела agenda).
///
/// Деривация поверх загруженной недели ([scheduleWeekProvider]) и выбранного
/// дня ([selectedScheduleDayProvider]): возвращает задачи именно этого дня
/// (порядок backend, по `dueAt`). Если день вне недели (рассинхрон) — пустой
/// список.
@riverpod
Future<List<CareTask>> selectedDayTasks(Ref ref) async {
  final weekStart = ref.watch(scheduleWeekStartProvider);
  final week = await ref.watch(scheduleWeekProvider(weekStart).future);
  final selected = ref.watch(selectedScheduleDayProvider);
  return _tasksOf(week.days, selected);
}

/// Готовое agenda-представление выбранного дня: секции утро/вечер/сделано +
/// счётчики «X из N готово».
///
/// Чистую деривацию делает [buildScheduleDayView] (тестируется отдельно без
/// Riverpod) — провайдер лишь собирает входы: задачи дня, начало сегодняшнего
/// дня (`clockProvider`, не `DateTime.now()`) и множество оптимистично
/// отмеченных задач ([scheduleMarkControllerProvider]).
///
/// Контракт для UI: `AsyncValue<ScheduleDayView>` (loading / error / data).
/// В `AsyncError` — типизированный `ApiError` (проброшен из недельного
/// провайдера), UI маппит его в текст через `AppLocalizations`.
@riverpod
Future<ScheduleDayView> scheduleDayView(Ref ref) async {
  final tasks = await ref.watch(selectedDayTasksProvider.future);
  final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();
  final startOfToday = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
  final doneKeys = ref.watch(scheduleMarkControllerProvider).doneKeys;

  return buildScheduleDayView(
    tasks: tasks,
    startOfToday: startOfToday,
    doneKeys: doneKeys,
  );
}

/// Задачи дня [date] из списка [days] (пустой список, если дня нет).
List<CareTask> _tasksOf(List<ScheduleDay> days, DateTime date) {
  final target = DateTime(date.year, date.month, date.day);
  for (final day in days) {
    final d = DateTime(day.date.year, day.date.month, day.date.day);
    if (d == target) return day.tasks;
  }
  return const [];
}
