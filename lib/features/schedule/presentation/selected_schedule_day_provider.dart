import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import 'schedule_week_start_provider.dart';

part 'selected_schedule_day_provider.g.dart';

/// Выбранный день недельного agenda-селектора экрана 11 «График».
///
/// Хранит локальную полночь выбранного дня. Старт — сегодня, если оно попадает
/// в текущую неделю (`clockProvider`, не `DateTime.now()` напрямую — FLUTTER.md
/// «Время»), иначе понедельник недели. Зависит от [scheduleWeekStartProvider]:
/// при листании недели выбор сбрасывается на первый день новой недели (или на
/// «сегодня», если оно туда попало) — иначе селектор показал бы день не из
/// видимой недели.
///
/// Контракт для UI: `ref.watch(selectedScheduleDayProvider)` → `DateTime`
/// (локальная полночь). Этот день — ключ для деривации списка задач дня.
@riverpod
class SelectedScheduleDay extends _$SelectedScheduleDay {
  @override
  DateTime build() {
    final weekStart = ref.watch(scheduleWeekStartProvider);
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = DateTime(start.year, start.month, start.day + 6);

    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);

    // Сегодня внутри видимой недели → выбираем его, иначе первый день недели.
    final inWeek = !today.isBefore(start) && !today.isAfter(end);
    return inWeek ? today : start;
  }

  /// Выбрать день недели (локальная полночь). Вне границ недели — игнор.
  void select(DateTime day) {
    final weekStart = ref.read(scheduleWeekStartProvider);
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = DateTime(start.year, start.month, start.day + 6);
    final picked = DateTime(day.year, day.month, day.day);
    if (picked.isBefore(start) || picked.isAfter(end)) return;
    state = picked;
  }
}
