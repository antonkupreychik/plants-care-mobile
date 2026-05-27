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
/// текущего локального момента), UI его не пересчитывает.
@freezed
abstract class TodayTaskItem with _$TodayTaskItem {
  const factory TodayTaskItem({
    required CareTask task,

    /// `dueAt.toLocal() < nowLocal` на момент деривации.
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
/// Сознательно отсутствует (backend-гэпы, см. задачу 03):
///  * `doneCount` / прогресс-кольцо «X из N» — `/today` отдаёт только pending;
///  * свёрнутая секция «N выполнено сегодня» — нет фида «выполнено»;
///  * voice line / mood растения (G2) — нет в API;
///  * speciesId / иллюстрация по виду (G6) — нет в TaskDto.
@freezed
abstract class TodayView with _$TodayView {
  const factory TodayView({
    /// Активный фильтр, под который построены [groups].
    required TodayFilter filter,

    /// Секции (утро/вечер) под текущим фильтром. Пустые фазы опущены.
    required List<TodayGroup> groups,

    /// Всего задач в исходном списке (пилюля «Всё»).
    required int totalCount,

    /// Кол-во задач `watering` (пилюля «Полив»).
    required int wateringCount,

    /// Кол-во задач `misting` (пилюля «Опрыскивание»).
    required int mistingCount,

    /// Кол-во задач `fertilizing` (пилюля «Подкормка»).
    required int fertilizingCount,

    /// Кол-во просроченных любого типа (пилюля «Просрочено» + summary).
    required int overdueCount,
  }) = _TodayView;

  const TodayView._();

  /// Нет задач под текущим фильтром (UI рисует пустое состояние секций).
  bool get isEmpty => groups.isEmpty;
}

/// Чистая деривация представления экрана 03 из задач `/today`.
///
/// Принимает [nowLocal] параметром (НЕ зовёт `DateTime.now()`), чтобы тест мог
/// подать фиксированный момент. UTC→local-конвертацию делает здесь: задача
/// просрочена при `task.dueAt.toLocal() < nowLocal`, фаза — по
/// `task.dueAt.toLocal().hour`.
///
/// Алгоритм:
///  1. счётчики — по ПОЛНОМУ [tasks] (для пилюль);
///  2. фильтрация по [filter];
///  3. группировка утро/вечер по локальному часу, сортировка внутри по `dueAt`;
///  4. пустые фазы опускаются.
TodayView buildTodayView({
  required List<CareTask> tasks,
  required DateTime nowLocal,
  required TodayFilter filter,
}) {
  bool isOverdue(CareTask task) => task.dueAt.toLocal().isBefore(nowLocal);

  var watering = 0;
  var misting = 0;
  var fertilizing = 0;
  var overdue = 0;
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
  for (final task in tasks) {
    if (!matchesFilter(task)) continue;
    final item = TodayTaskItem(task: task, overdue: isOverdue(task));
    final isMorning = task.dueAt.toLocal().hour < 12;
    (isMorning ? morning : evening).add(item);
  }

  int byDueAt(TodayTaskItem a, TodayTaskItem b) =>
      a.task.dueAt.compareTo(b.task.dueAt);
  morning.sort(byDueAt);
  evening.sort(byDueAt);

  final groups = <TodayGroup>[
    if (morning.isNotEmpty)
      TodayGroup(phase: TodayPhase.morning, items: morning),
    if (evening.isNotEmpty)
      TodayGroup(phase: TodayPhase.evening, items: evening),
  ];

  return TodayView(
    filter: filter,
    groups: groups,
    totalCount: tasks.length,
    wateringCount: watering,
    mistingCount: misting,
    fertilizingCount: fertilizing,
    overdueCount: overdue,
  );
}
