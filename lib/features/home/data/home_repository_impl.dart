import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/care_task.dart';
import '../domain/garden_location.dart';
import '../domain/home_repository.dart';
import '../domain/plant.dart';
import 'mappers/location_mapper.dart';
import 'mappers/plant_mapper.dart';
import 'mappers/task_mapper.dart';

/// Реализация [HomeRepository] поверх сгенерированного API-клиента (MADR-007).
///
/// На каждый запрос проставляет [AuthScope] через `authScopeExtra` — заголовок
/// (`X-Chat-Id` / `X-User-Id`) подставит `AuthInterceptor` из текущей
/// `AuthSession` (MADR-006/008). Поэтому идентичность здесь НЕ хардкодится:
/// см. [_headerOverriddenByInterceptor].
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в `DioException.error`;
/// здесь это разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Значение для required-параметра `@Header` сгенерированного клиента.
  ///
  /// Генератор требует `int` для `X-Chat-Id` / `X-User-Id`, но реальный
  /// заголовок ставит `AuthInterceptor` из `AuthSession` и ПЕРЕЗАПИСЫВАЕТ это
  /// значение (`headers.addAll`). Идентичность живёт в одном месте (auth-слот),
  /// data-слой её не знает и не хардкодит — это лишь заглушка обязательного поля.
  static const int _headerOverriddenByInterceptor = 0;

  @override
  Future<Result<List<CareTask>>> getTodayTasks() async {
    try {
      final response = await _api.today.getToday(
        xChatId: _headerOverriddenByInterceptor,
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
        xUserId: _headerOverriddenByInterceptor,
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
        xUserId: _headerOverriddenByInterceptor,
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
