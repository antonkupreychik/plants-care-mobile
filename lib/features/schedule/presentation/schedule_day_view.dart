import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task.dart';

part 'schedule_day_view.freezed.dart';

/// Дневная фаза задачи на экране 11 «График» (agenda-паттерн).
///
/// Граница — `dueAt.toLocal().hour < 12` → [morning], иначе → [evening]
/// (FLUTTER.md «Время»: группировку «утро/вечер» считает presentation,
/// не domain). [done] — отдельная фаза для отмеченных в этой сессии задач.
enum ScheduleAgendaPhase { morning, evening, done }

/// Задача дня + presentation-флаги для строки agenda.
///
/// Чистый Dart: обёртка над доменной [CareTask], которую UI рисует строкой.
/// [overdue] вычислен в [buildScheduleDayView] (дедлайн строго раньше начала
/// сегодняшнего дня), [done] — была ли задача отмечена оптимистично в текущей
/// сессии. UI их не пересчитывает.
@freezed
abstract class ScheduleTaskItem with _$ScheduleTaskItem {
  const factory ScheduleTaskItem({
    required CareTask task,

    /// `task.dueAt.toLocal() < startOfToday` (просрочка относительно сегодня).
    required bool overdue,

    /// Задача отмечена выполненной в текущей сессии (оптимистично).
    required bool done,
  }) = _ScheduleTaskItem;
}

/// Секция дня (утро / вечер / сделано) с отсортированными задачами.
@freezed
abstract class ScheduleAgendaGroup with _$ScheduleAgendaGroup {
  const factory ScheduleAgendaGroup({
    required ScheduleAgendaPhase phase,

    /// Задачи фазы. Для morning/evening — по `dueAt` возрастанию.
    required List<ScheduleTaskItem> items,
  }) = _ScheduleAgendaGroup;
}

/// Готовое к отрисовке представление одного дня экрана 11 «График».
///
/// Чистый, иммутабельный результат деривации [buildScheduleDayView] из задач
/// дня + текущего локального момента + множества оптимистично отмеченных задач.
/// [groups] — секции (утро/вечер/сделано), пустые опущены; [doneCount] и
/// [totalCount] — для подзаголовка «X из N готово».
@freezed
abstract class ScheduleDayView with _$ScheduleDayView {
  const factory ScheduleDayView({
    /// Секции (утро/вечер/сделано) в порядке отрисовки. Пустые опущены.
    required List<ScheduleAgendaGroup> groups,

    /// Всего задач дня (для подзаголовка «X из N готово»).
    required int totalCount,

    /// Сколько из них отмечено выполненными в текущей сессии.
    required int doneCount,
  }) = _ScheduleDayView;

  const ScheduleDayView._();

  /// В дне нет ни одной задачи (UI рисует дружелюбную заглушку).
  bool get isEmpty => totalCount == 0;
}

/// Уникальный ключ задачи для отметки «выполнено» в рамках дня.
///
/// `scheduleId` уникален в пределах дня (одна задача = одно расписание на дату),
/// этого достаточно как идентификатор оптимистичной отметки.
typedef ScheduleTaskKey = int;

/// Ключ задачи для множества «отмечено выполненным».
ScheduleTaskKey scheduleTaskKeyOf(CareTask task) => task.scheduleId;

/// Чистая деривация представления дня экрана 11 из задач `/calendar`.
///
/// Принимает [startOfToday] параметром (НЕ зовёт `DateTime.now()`), чтобы тест
/// мог подать фиксированный момент. UTC→local-конвертацию делает здесь:
/// задача просрочена при `task.dueAt.toLocal() < startOfToday`, фаза — по
/// `task.dueAt.toLocal().hour`. [doneKeys] — задачи, отмеченные оптимистично
/// (по [scheduleTaskKeyOf]); они уходят в секцию «Сделано».
///
/// Алгоритм:
///  1. задачи из [doneKeys] → секция «Сделано»;
///  2. остальные группируются утро/вечер по локальному часу дедлайна;
///  3. внутри morning/evening сортировка по `dueAt`;
///  4. пустые секции опускаются.
ScheduleDayView buildScheduleDayView({
  required List<CareTask> tasks,
  required DateTime startOfToday,
  required Set<ScheduleTaskKey> doneKeys,
}) {
  bool isOverdue(CareTask task) => task.dueAt.toLocal().isBefore(startOfToday);

  final morning = <ScheduleTaskItem>[];
  final evening = <ScheduleTaskItem>[];
  final done = <ScheduleTaskItem>[];

  for (final task in tasks) {
    final isDone = doneKeys.contains(scheduleTaskKeyOf(task));
    final item = ScheduleTaskItem(
      task: task,
      overdue: !isDone && isOverdue(task),
      done: isDone,
    );
    if (isDone) {
      done.add(item);
      continue;
    }
    final isMorning = task.dueAt.toLocal().hour < 12;
    (isMorning ? morning : evening).add(item);
  }

  int byDueAt(ScheduleTaskItem a, ScheduleTaskItem b) =>
      a.task.dueAt.compareTo(b.task.dueAt);
  morning.sort(byDueAt);
  evening.sort(byDueAt);

  final groups = <ScheduleAgendaGroup>[
    if (morning.isNotEmpty)
      ScheduleAgendaGroup(phase: ScheduleAgendaPhase.morning, items: morning),
    if (evening.isNotEmpty)
      ScheduleAgendaGroup(phase: ScheduleAgendaPhase.evening, items: evening),
    if (done.isNotEmpty)
      ScheduleAgendaGroup(phase: ScheduleAgendaPhase.done, items: done),
  ];

  return ScheduleDayView(
    groups: groups,
    totalCount: tasks.length,
    doneCount: done.length,
  );
}
