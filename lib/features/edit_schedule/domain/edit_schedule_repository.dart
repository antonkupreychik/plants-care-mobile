import '../../../core/error/result.dart';
import 'plant_care_schedule.dart';

/// Контракт data-слоя фичи «Редактирование расписания ухода» (экран 22).
///
/// User-scoped (идентификация по `X-User-Id`, как у `/plants`). Возвращает
/// `Future<Result<T>>` и НЕ бросает наружу (MADR-011). Интервалы и `nextDueAt`
/// считает backend — клиент их не пересчитывает.
abstract interface class EditScheduleRepository {
  /// Список расписаний растения (`GET /plants/{id}/schedules`).
  Future<Result<List<PlantCareSchedule>>> getSchedules(int plantId);

  /// Обновляет одно расписание (`PUT /plants/{id}/schedules/{type}`).
  ///
  /// Тип берётся из [schedule.type]; редактируемые поля (`every`, `unit`,
  /// `amountMl`, `enabled`) маппятся в `CareScheduleUpdateRequest`. Возвращает
  /// обновлённое расписание с пересчитанным backend `nextDueAt`.
  Future<Result<PlantCareSchedule>> updateSchedule(
    int plantId,
    PlantCareSchedule schedule,
  );
}
