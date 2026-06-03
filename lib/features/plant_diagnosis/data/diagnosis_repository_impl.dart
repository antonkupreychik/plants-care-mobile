import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/diagnosis_repository.dart';
import '../domain/plant_diagnosis.dart';
import 'diagnosis_mapper.dart';

/// Реализация [DiagnosisRepository] поверх сгенерированного API-клиента
/// (MADR-007). Один запрос — `GET /plants/{id}/diagnosis`, scope user
/// (bearer JWT; `AuthInterceptor` подставит заголовок из текущей `AuthSession`,
/// MADR-006/008). Идентичность не хардкодится.
///
/// Ошибки dio нормализует `ErrorInterceptor` → `ApiError` в
/// `DioException.error`; здесь разворачиваем в `Result.failure` (MADR-011).
class DiagnosisRepositoryImpl implements DiagnosisRepository {
  const DiagnosisRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<PlantDiagnosis>> getDiagnosis(int plantId) async {
    try {
      final dto = await _api.plants.getPlantDiagnosis(
        id: plantId,
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
