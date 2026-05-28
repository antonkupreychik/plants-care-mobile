import 'package:dio/dio.dart';

import '../../../core/api/generated/models/location_create_request.dart';
import '../../../core/api/generated/models/location_update_request.dart';
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
/// заголовок `X-User-Id` подставит `AuthInterceptor` из текущей `AuthSession`
/// (MADR-006/008). Идентичность здесь НЕ хардкодится: см.
/// [_headerOverriddenByInterceptor].
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class RoomsRepositoryImpl implements RoomsRepository {
  const RoomsRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Значение для required-параметра `@Header` сгенерированного клиента.
  ///
  /// Генератор требует `int` для `X-User-Id`, но реальный заголовок ставит
  /// `AuthInterceptor` из `AuthSession` и ПЕРЕЗАПИСЫВАЕТ это значение. Data-слой
  /// идентичность не знает и не хардкодит — это лишь заглушка обязательного поля.
  static const int _headerOverriddenByInterceptor = 0;

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

  @override
  Future<Result<GardenLocation>> createLocation({
    required String name,
    String? emoji,
  }) async {
    try {
      final dto = await _api.locations.createLocation(
        xUserId: _headerOverriddenByInterceptor,
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
        xUserId: _headerOverriddenByInterceptor,
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
    int? targetLocationId,
  }) async {
    try {
      await _api.locations.deleteLocation(
        xUserId: _headerOverriddenByInterceptor,
        id: id,
        targetLocationId: targetLocationId,
        extras: authScopeExtra(AuthScope.user),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
