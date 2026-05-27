import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';

part 'schedule_week_start_provider.g.dart';

/// Навигация по неделям экрана «График» (11): хранит понедельник выбранной
/// недели (локальная полночь).
///
/// Старт — понедельник текущей недели, посчитанный из `clockProvider` (в TZ
/// пользователя), а не из `DateTime.now()` напрямую (FLUTTER.md «Время»;
/// тестируется через `FakeClock`). [nextWeek]/[previousWeek] двигают на ±7 дней;
/// жёстких границ листания нет (каждая неделя — отдельный 7-дневный запрос,
/// лимит 60 дней не достигается).
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekStartProvider)` → `DateTime`
/// (понедельник, локальная полночь). Этот же `DateTime` передаётся как ключ
/// в `scheduleWeekProvider(weekStart)`.
@riverpod
class ScheduleWeekStart extends _$ScheduleWeekStart {
  @override
  DateTime build() {
    final nowLocal = ref.watch(clockProvider).nowUtc().toLocal();
    return _mondayOf(nowLocal);
  }

  /// Следующая неделя (+7 дней).
  void nextWeek() => state = _addDays(state, 7);

  /// Предыдущая неделя (−7 дней).
  void previousWeek() => state = _addDays(state, -7);

  /// Сброс на понедельник текущей недели (кнопка «Сегодня»).
  void resetToCurrentWeek() {
    final nowLocal = ref.read(clockProvider).nowUtc().toLocal();
    state = _mondayOf(nowLocal);
  }
}

/// Понедельник (локальная полночь) недели, содержащей [local].
/// `DateTime.weekday`: Пн=1 … Вс=7, поэтому сдвиг назад = `weekday - 1` дней.
DateTime _mondayOf(DateTime local) {
  final dateOnly = DateTime(local.year, local.month, local.day);
  return _addDays(dateOnly, -(dateOnly.weekday - DateTime.monday));
}

/// Прибавляет [days] к date-only [date] (корректно через нормализацию y/m/d).
DateTime _addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);
