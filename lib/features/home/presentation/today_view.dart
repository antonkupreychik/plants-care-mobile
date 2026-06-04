import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task.dart';
import '../../../core/care/care_task_type.dart';
import 'today_filter.dart';

part 'today_view.freezed.dart';

/// Дневная фаза задачи на экране 03, по локальному часу дедлайна.
///
/// Граница — `dueAt.toLocal().hour < 12` → [morning], иначе → [evening]
/// (FLUTTER.md «Время»: группировку «утро/вечер» считает presentation, не domain).
enum TodayPhase { morning, evening }

/// Задача ухода + presentation-флаг просрочки.
///
/// Чистый Dart: обёртка над доменной [CareTask], которую UI рисует строкой
/// списка. [overdue] вычислен в [buildTodayView] (дедлайн строго раньше
/// текущего локального момента), UI его не пересчитывает. Выполненные задачи
/// (`task.isDone`) попадают не в секции, а в свёрнутую секцию «Выполнено» и
/// никогда не помечаются [overdue].
@freezed
abstract class TodayTaskItem with _$TodayTaskItem {
  const factory TodayTaskItem({
    required CareTask task,

    /// `dueAt.toLocal() < nowLocal` на момент деривации (для невыполненных).
    required bool overdue,
  }) = _TodayTaskItem;
}

/// Секция «утро»/«вечер» с отсортированными по [CareTask.dueAt] задачами.
@freezed
abstract class TodayGroup with _$TodayGroup {
  const factory TodayGroup({
    required TodayPhase phase,

    /// Задачи фазы, отсортированы по `dueAt` возрастанию.
    required List<TodayTaskItem> items,
  }) = _TodayGroup;
}

/// Готовое к отрисовке представление экрана 03 «Сегодня».
///
/// Чистый, иммутабельный результат деривации [buildTodayView] из
/// `List<CareTask>` + текущего локального момента. Счётчики ([totalCount],
/// [wateringCount], [mistingCount], [fertilizingCount], [overdueCount])
/// считаются по ПОЛНОМУ списку (для пилюль), а [groups] — уже под выбранный
/// [TodayFilter] (отфильтровано → сгруппировано → отсортировано).
///
/// Выполненные сегодня задачи (`CareTask.isDone`, `TaskDto.doneAt != null`,
/// backend gap G11 закрыт) НЕ попадают в [groups] — они уходят в [doneItems]
/// (свёрнутая секция «Выполнено»). [doneCount] / [totalCount] питают
/// прогресс-карточку «X из N выполнено».
///
/// Иллюстрация по виду (G6) доступна: `TaskDto` отдаёт `speciesName`
/// (см. [CareTask.speciesName]), карточки задач рисуют `PlantIllustration`.
@freezed
abstract class TodayView with _$TodayView {
  const factory TodayView({
    /// Активный фильтр, под который построены [groups].
    required TodayFilter filter,

    /// Секции (утро/вечер) НЕвыполненных задач под текущим фильтром.
    /// Пустые фазы опущены.
    required List<TodayGroup> groups,

    /// Выполненные сегодня задачи (свёрнутая секция «Выполнено»),
    /// отсортированы по `doneAt` убыванию (последняя — сверху).
    /// Фильтр-пилюли на эту секцию НЕ влияют (она показывает все done).
    required List<TodayTaskItem> doneItems,

    /// Всего задач в исходном списке, включая выполненные (пилюля «Всё» + N в
    /// прогресс-карточке «X из N»).
    required int totalCount,

    /// Сколько задач выполнено сегодня (`isDone`) — числитель прогресса.
    required int doneCount,

    /// Кол-во задач `watering` (пилюля «Полив»), по полному списку.
    required int wateringCount,

    /// Кол-во задач `misting` (пилюля «Опрыскивание»), по полному списку.
    required int mistingCount,

    /// Кол-во задач `fertilizing` (пилюля «Подкормка»), по полному списку.
    required int fertilizingCount,

    /// Кол-во просроченных НЕвыполненных задач любого типа
    /// (пилюля «Просрочено» + summary). Выполненные не считаются просроченными.
    required int overdueCount,
  }) = _TodayView;

  const TodayView._();

  /// Нет НЕвыполненных секций (UI рисует пустое состояние секций).
  bool get isEmpty => groups.isEmpty;

  /// Есть ли выполненные задачи (рисовать свёрнутую секцию «Выполнено»).
  bool get hasDone => doneItems.isNotEmpty;

  /// Осталось невыполненных (`total - done`) — для подписи прогресса.
  int get remainingCount => totalCount - doneCount;
}

/// Чистая деривация представления экрана 03 из задач `/today`.
///
/// Принимает [nowLocal] параметром (НЕ зовёт `DateTime.now()`), чтобы тест мог
/// подать фиксированный момент. UTC→local-конвертацию делает здесь: задача
/// просрочена при `task.dueAt.toLocal() < nowLocal`, фаза — по
/// `task.dueAt.toLocal().hour`.
///
/// Алгоритм:
///  1. счётчики по типам — по ПОЛНОМУ [tasks] (включая выполненные, для пилюль);
///  2. выполненные (`task.isDone`) откладываем в `doneItems` (сорт по `doneAt`
///     убыв.), они НЕ попадают в секции и не считаются overdue;
///  3. невыполненные фильтруем по [filter];
///  4. группировка утро/вечер по локальному часу, сортировка внутри по `dueAt`;
///  5. пустые фазы опускаются.
TodayView buildTodayView({
  required List<CareTask> tasks,
  required DateTime nowLocal,
  required TodayFilter filter,
}) {
  // Просрочка определена только для невыполненных задач.
  bool isOverdue(CareTask task) =>
      !task.isDone && task.dueAt.toLocal().isBefore(nowLocal);

  var watering = 0;
  var misting = 0;
  var fertilizing = 0;
  var overdue = 0;
  var done = 0;
  for (final task in tasks) {
    switch (task.type) {
      case CareTaskType.watering:
        watering++;
      case CareTaskType.misting:
        misting++;
      case CareTaskType.fertilizing:
        fertilizing++;
      case CareTaskType.soilCheck:
      case CareTaskType.unknown:
        break;
    }
    if (task.isDone) done++;
    if (isOverdue(task)) overdue++;
  }

  bool matchesFilter(CareTask task) => switch (filter) {
        TodayFilter.all => true,
        TodayFilter.watering => task.type == CareTaskType.watering,
        TodayFilter.misting => task.type == CareTaskType.misting,
        TodayFilter.fertilizing => task.type == CareTaskType.fertilizing,
        TodayFilter.overdue => isOverdue(task),
      };

  final morning = <TodayTaskItem>[];
  final evening = <TodayTaskItem>[];
  final doneItems = <TodayTaskItem>[];
  for (final task in tasks) {
    if (task.isDone) {
      doneItems.add(TodayTaskItem(task: task, overdue: false));
      continue;
    }
    if (!matchesFilter(task)) continue;
    final item = TodayTaskItem(task: task, overdue: isOverdue(task));
    final isMorning = task.dueAt.toLocal().hour < 12;
    (isMorning ? morning : evening).add(item);
  }

  int byDueAt(TodayTaskItem a, TodayTaskItem b) =>
      a.task.dueAt.compareTo(b.task.dueAt);
  morning.sort(byDueAt);
  evening.sort(byDueAt);

  // Выполненные — последняя отметка сверху (по убыванию doneAt).
  doneItems.sort((a, b) => b.task.doneAt!.compareTo(a.task.doneAt!));

  final groups = <TodayGroup>[
    if (morning.isNotEmpty)
      TodayGroup(phase: TodayPhase.morning, items: morning),
    if (evening.isNotEmpty)
      TodayGroup(phase: TodayPhase.evening, items: evening),
  ];

  return TodayView(
    filter: filter,
    groups: groups,
    doneItems: doneItems,
    totalCount: tasks.length,
    doneCount: done,
    wateringCount: watering,
    mistingCount: misting,
    fertilizingCount: fertilizing,
    overdueCount: overdue,
  );
}
