import '../../../core/error/result.dart';
import 'plant_family.dart';

/// Контракт data-слоя экрана «Родословная / размножение» (18).
///
/// Одно чтение — родословная растения (`GET /plants/{id}/family`). Возвращает
/// `Future<Result<T>>` и НЕ бросает наружу (MADR-011): ошибка видна в типе,
/// presentation разворачивает её в `AsyncError`/баннер.
abstract interface class PlantFamilyRepository {
  /// Родословная растения: материнское растение и прямые потомки
  /// (`GET /plants/{id}/family`, scope user).
  Future<Result<PlantFamily>> getFamily(int plantId);
}
