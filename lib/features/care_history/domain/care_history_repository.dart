import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../../plant_card/domain/streak.dart';
import 'care_history_page.dart';

/// Контракт data-слоя для экрана «Полная история ухода» (21).
///
/// Три независимых чтения одного экрана: страница истории (пагинация),
/// деталь растения (имя в шапке + `createdAt` — маркер появления растения)
/// и стрик. Каждое падает независимо (presentation держит их в отдельных
/// провайдерах), поэтому методы отдельные, а не один агрегат. Возвращают
/// `Future<Result<T>>` и НЕ бросают наружу (MADR-011).
///
/// [Plant] и [Streak] переиспользуются из domain соседних фич (`home`,
/// `plant_card`) — не дублируем. Фича может зависеть от domain другой фичи,
/// но НЕ от её presentation (FLUTTER.md / MADR-003).
abstract interface class CareHistoryRepository {
  /// Страница истории ухода (`GET /plants/{id}/history`, scope chat).
  /// [limit] — размер страницы (backend требует диапазон [1, 100]);
  /// [offset] — сдвиг от начала истории (значения < 0 backend нормализует в 0).
  Future<Result<CareHistoryPage>> getHistoryPage(
    int plantId, {
    int limit,
    int offset,
  });

  /// Стрик растения (`GET /stats/streak`, scope chat).
  Future<Result<Streak>> getStreak(int plantId);

  /// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
  /// `createdAt` для маркера появления растения в таймлайне.
  Future<Result<Plant>> getPlant(int plantId);
}
