import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';

/// Контракт data-слоя фичи «Управление комнатами» — полный CRUD локаций
/// (`/api/v1/locations`, scope user).
///
/// Все методы возвращают `Future<Result<T>>` и НЕ бросают наружу: доменные
/// ошибки backend (`{error:{code,...}}`) приходят как [ApiError] в `Failure`
/// (MADR-011). Реализация скрыта в data, presentation зависит только от этого
/// интерфейса (MADR-002).
///
/// Domain-модель [GardenLocation] — общее ядро (`core/locations/`), делят
/// `home` и `rooms`.
abstract interface class RoomsRepository {
  /// Список локаций пользователя (`GET /locations`). Без пагинации.
  Future<Result<List<GardenLocation>>> getLocations();

  /// Создать локацию (`POST /locations`).
  ///
  /// [name] обязателен, уникален в рамках пользователя (коллизия → 400
  /// `BAD_REQUEST`). [emoji] — опциональная иконка.
  Future<Result<GardenLocation>> createLocation({
    required String name,
    String? emoji,
  });

  /// Обновить локацию (`PUT /locations/{id}`, PATCH-семантика).
  ///
  /// Передаются только заданные поля: `null` означает «не менять», поэтому
  /// в [LocationUpdateRequest] кладём именно переданные аргументы как есть.
  Future<Result<GardenLocation>> updateLocation({
    required int id,
    String? name,
    String? emoji,
  });

  /// Удалить локацию (`DELETE /locations/{id}`).
  ///
  /// Если в локации есть растения — backend требует [targetLocationId] (куда
  /// перенести), иначе вернёт 400 `LOCATION_NOT_EMPTY`
  /// ([ApiError.locationNotEmpty]). UI ловит этот случай, показывает пикер
  /// целевой локации и повторяет вызов с [targetLocationId]. Если растений
  /// нет — [targetLocationId] игнорируется backend'ом.
  Future<Result<void>> deleteLocation({
    required int id,
    int? targetLocationId,
  });
}
