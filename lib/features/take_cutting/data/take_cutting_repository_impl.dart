import 'package:dio/dio.dart';

import '../../../core/api/generated/models/plant_create_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/take_cutting_repository.dart';

/// Реализация [TakeCuttingRepository] поверх сгенерированного API-клиента
/// (MADR-007). Зеркалит `AddPlantRepositoryImpl`.
///
/// `POST /plants` помечается [AuthScope.user] (`Authorization` ставит
/// `AuthInterceptor` из `AuthSession`; data идентичность не знает).
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class TakeCuttingRepositoryImpl implements TakeCuttingRepository {
  const TakeCuttingRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<int>> createCutting({
    required String name,
    required int parentPlantId,
  }) async {
    try {
      final dto = await _api.plants.createPlant(
        body: PlantCreateRequest(
          name: name,
          parentPlantId: parentPlantId,
        ),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.id);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
