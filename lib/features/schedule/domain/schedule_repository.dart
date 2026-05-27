import '../../../core/error/result.dart';
import 'schedule_week.dart';

/// Контракт data-слоя для экрана «График» (11), источник — `GET /calendar`.
///
/// Высокоуровневый метод: presentation всегда оперирует целыми неделями
/// (листание Пн→Вс), а не произвольным диапазоном. Поэтому интерфейс отдаёт
/// готовый [ScheduleWeek] (ровно 7 дней с дырами заполнены), а раскладку
/// «from/to → 7 дней» инкапсулирует реализация. Метод возвращает
/// `Future<Result<T>>` и НЕ бросает наружу (MADR-011).
///
/// Domain-контракт: реализация скрыта в data, presentation зависит только
/// от этого интерфейса (MADR-002).
abstract interface class ScheduleRepository {
  /// Неделя графика, начиная с [weekStart] (понедельник, локальная полночь).
  ///
  /// Реализация запрашивает `/calendar?from=weekStart&to=weekStart+6д`
  /// (7 дней — лимит 60 дней не достигается) и собирает [ScheduleWeek].
  Future<Result<ScheduleWeek>> getWeek({required DateTime weekStart});
}
