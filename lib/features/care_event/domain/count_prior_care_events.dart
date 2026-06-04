import '../../../core/error/result.dart';
import 'care_event_repository.dart';

/// Use case: сколько событий ухода у растения УЖЕ записано (до текущего
/// действия). Одна ответственность, один публичный метод (MADR-002).
///
/// Питает детекцию «первого ухода» (экран 33): если `count == 0`, следующее
/// действие — первое. Делегирует в репозиторий; не бросает наружу (`Result`).
class CountPriorCareEvents {
  const CountPriorCareEvents(this._repository);

  final CareEventRepository _repository;

  /// Возвращает число уже записанных событий ухода растения [plantId].
  Future<Result<int>> call(int plantId) =>
      _repository.priorCareEventCount(plantId);
}
