import 'package:dio/dio.dart';

import '../../../core/api/generated/models/plant_update_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../../home/data/mappers/plant_mapper.dart';
import '../../home/domain/plant.dart';
import '../domain/edit_plant_draft.dart';
import '../domain/edit_plant_repository.dart';

/// Реализация [EditPlantRepository] поверх сгенерированного API-клиента.
///
/// `PUT /plants/{id}` — scope [AuthScope.user] (`X-User-Id` подставит
/// `AuthInterceptor`). Ошибки dio ловит `ErrorInterceptor` и кладёт
/// [ApiError] в `DioException.error`; здесь разворачивается в `Result.failure`.
class EditPlantRepositoryImpl implements EditPlantRepository {
  const EditPlantRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<Plant>> updatePlant(int id, EditPlantDraft draft) async {
    try {
      final dto = await _api.plants.updatePlant(
        id: id,
        body: PlantUpdateRequest(
          name: draft.name.trim().isEmpty ? null : draft.name.trim(),
          notes: draft.notes,
          locationId: draft.locationId,
        ),
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
