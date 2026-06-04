import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/care/care_task.dart';
import '../../../core/care/task_mapper.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
import '../../../core/locations/location_mapper.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/home_repository.dart';
import '../domain/plant.dart';
import 'mappers/plant_mapper.dart';

/// Реализация [HomeRepository] поверх сгенерированного API-клиента (MADR-007).
///
/// На каждый запрос проставляет [AuthScope] через `authScopeExtra` — заголовок
/// (`Authorization: Bearer`) подставит `AuthInterceptor` из текущей
/// `AuthSession` (MADR-006/008). Поэтому идентичность здесь НЕ хардкодится:
/// см. `AuthInterceptor`.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в `DioException.error`;
/// здесь это разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<List<CareTask>>> getTodayTasks() async {
    try {
      final response = await _api.today.getToday(
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(
        response.tasks.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<List<Plant>>> getPlants({int limit = 50}) async {
    try {
      final response = await _api.plants.listPlants(
        limit: limit,
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(
        response.items.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

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

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если по какой-то причине там не [ApiError] —
  /// безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
