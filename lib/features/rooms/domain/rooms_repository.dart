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
  /// Issue #250: каскадного переноса растений больше нет. Если в локации есть
  /// активные растения — backend возвращает 409 `LOCATION_NOT_EMPTY`
  /// ([ApiError.locationNotEmpty]). Растения нужно перенести заранее
  /// (`PATCH /plants/{id}` с новым `locationId`), затем удалять пустую локацию.
  ///
  /// [targetLocationId] оставлен для обратной совместимости UI-флоу переноса,
  /// но backend его больше не принимает и значение игнорируется.
  Future<Result<void>> deleteLocation({
    required int id,
    int? targetLocationId,
  });

  /// Перенести все растения из [fromLocationId] в [targetLocationId] и удалить
  /// исходную локацию — клиентский каскад вместо убранного серверного
  /// (issue #183/#250).
  ///
  /// Шаги: (1) постранично собрать ВСЕ растения локации
  /// (`GET /plants?locationId=`, offset/limit до конца); (2) каждому
  /// `PATCH /plants/{id}` с новым `locationId`; (3) только если ВСЕ перенесены —
  /// `DELETE /locations/{fromLocationId}`.
  ///
  /// При любой ошибке переноса локация НЕ удаляется и возвращается `Failure`
  /// (уже перенесённые растения остаются у target — приемлемо: данные не
  /// теряются, непустая локация не удаляется).
  Future<Result<void>> movePlantsAndDelete({
    required int fromLocationId,
    required int targetLocationId,
  });
}
