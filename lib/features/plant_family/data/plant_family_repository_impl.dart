import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/plant_family.dart';
import '../domain/plant_family_repository.dart';
import 'mappers/plant_family_mapper.dart';

/// Реализация [PlantFamilyRepository] поверх сгенерированного API-клиента
/// (MADR-007). Помечает запрос [AuthScope.user] через `authScopeExtra` —
/// заголовок `Authorization: Bearer` подставит `AuthInterceptor` из текущей
/// `AuthSession` (MADR-006/008). Идентичность здесь НЕ хардкодится.
///
/// Маппинг DTO ↔ domain — через `PlantFamilyResponseMapper.toDomain()`
/// (отдельный, покрыт тестом). Ошибки dio ловит `ErrorInterceptor` и кладёт
/// [ApiError] в `DioException.error`; здесь это разворачивается в
/// `Result.failure` (MADR-011), наружу не бросаем.
class PlantFamilyRepositoryImpl implements PlantFamilyRepository {
  const PlantFamilyRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<PlantFamily>> getFamily(int plantId) async {
    try {
      final response = await _api.plants.getPlantFamily(
        id: plantId,
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(response.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
