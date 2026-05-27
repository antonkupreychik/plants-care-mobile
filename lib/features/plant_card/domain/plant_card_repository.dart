import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import 'care_history_entry.dart';
import 'streak.dart';

/// Контракт data-слоя для экрана «Карточка растения» (02).
///
/// Три независимых чтения одного экрана: деталь растения, история ухода, стрик.
/// Каждое падает независимо (presentation держит их в отдельных провайдерах),
/// поэтому методы отдельные, а не один агрегат. Возвращают `Future<Result<T>>`
/// и НЕ бросают наружу (MADR-011).
///
/// [Plant] переиспользуется из domain фичи `home` (модель та же, `PlantDto`) —
/// не дублируем. Фича может зависеть от domain другой фичи, но НЕ от её
/// presentation (FLUTTER.md / MADR-003).
abstract interface class PlantCardRepository {
  /// Деталь растения (`GET /plants/{id}`, scope user).
  Future<Result<Plant>> getPlant(int plantId);

  /// История ухода (`GET /plants/{id}/history`, scope chat).
  /// [limit] — размер страницы (backend требует диапазон [1, 100]).
  Future<Result<List<CareHistoryEntry>>> getHistory(
    int plantId, {
    int limit,
  });

  /// Стрик растения (`GET /stats/streak`, scope chat).
  Future<Result<Streak>> getStreak(int plantId);
}
