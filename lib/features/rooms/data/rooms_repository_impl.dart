import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../../core/api/generated/models/location_create_request.dart';
import '../../../core/api/generated/models/location_update_request.dart';
import '../../../core/api/generated/models/plant_update_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
import '../../../core/locations/location_mapper.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/rooms_repository.dart';

/// Реализация [RoomsRepository] поверх сгенерированного API-клиента (MADR-007).
///
/// На каждый запрос проставляет [AuthScope.user] через `authScopeExtra` —
/// заголовок `Authorization` подставит `AuthInterceptor` из текущей `AuthSession`
/// (MADR-006/008). Идентичность здесь НЕ хардкодится: см.
/// `AuthInterceptor`.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class RoomsRepositoryImpl implements RoomsRepository {
  const RoomsRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<List<GardenLocation>>> getLocations() async {
    try {
      final response = await _api.locations.listLocations(
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(
        response.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<GardenLocation>> createLocation({
    required String name,
    String? emoji,
  }) async {
    try {
      final dto = await _api.locations.createLocation(
        body: LocationCreateRequest(name: name, emoji: emoji),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<GardenLocation>> updateLocation({
    required int id,
    String? name,
    String? emoji,
  }) async {
    try {
      // PATCH-семантика: шлём только заданные поля. `null` в DTO → поле не
      // сериализуется (backend трактует отсутствие как «не менять»).
      final dto = await _api.locations.updateLocation(
        id: id,
        body: LocationUpdateRequest(name: name, emoji: emoji),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> deleteLocation({
    required int id,
    // Issue #250: backend больше не принимает targetLocationId (каскадного
    // переноса нет). Параметр сохранён в сигнатуре для совместимости UI-флоу,
    // но в запрос не передаётся; непустая локация → 409 LOCATION_NOT_EMPTY.
    int? targetLocationId,
  }) async {
    try {
      await _api.locations.deleteLocation(
        id: id,
        extras: authScopeExtra(AuthScope.user),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> movePlantsAndDelete({
    required int fromLocationId,
    required int targetLocationId,
  }) async {
    try {
      // 1. Постранично собираем ВСЕ id растений исходной локации. Backend
      // обрезает limit до [1,100]; идём offset/limit, пока не выберем total.
      const pageSize = 100;
      final plantIds = <int>[];
      var offset = 0;
      while (true) {
        final page = await _api.plants.listPlants(
          locationId: fromLocationId,
          offset: offset,
          limit: pageSize,
          extras: authScopeExtra(AuthScope.user),
        );
        plantIds.addAll(page.items.map((p) => p.id));
        offset += page.items.length;
        // Стоп: дошли до total ИЛИ страница пустая (защита от зацикливания).
        if (page.items.isEmpty || offset >= page.total) break;
      }

      // 2. Переносим каждое растение в целевую локацию (PATCH locationId).
      // Любая ошибка переноса → НЕ удаляем локацию, возвращаем Failure;
      // уже перенесённые остаются у target (данные не теряем).
      for (final plantId in plantIds) {
        await _api.plants.updatePlant(
          id: plantId,
          body: PlantUpdateRequest(locationId: targetLocationId),
          extras: authScopeExtra(AuthScope.user),
        );
      }

      // 3. Все растения перенесены (или их не было) → удаляем пустую локацию.
      await _api.locations.deleteLocation(
        id: fromLocationId,
        extras: authScopeExtra(AuthScope.user),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      final error = _toApiError(e);
      developer.log(
        'movePlantsAndDelete failed: from=$fromLocationId '
        'target=$targetLocationId error=$error',
        name: 'RoomsRepository',
        error: e,
      );
      return Result.failure(error);
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
