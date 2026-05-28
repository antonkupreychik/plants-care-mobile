import 'package:dio/dio.dart';

import '../../../core/api/generated/models/plant_create_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/add_plant_repository.dart';
import '../domain/species_detail.dart';
import '../domain/species_summary.dart';
import 'mappers/species_mapper.dart';

/// Реализация [AddPlantRepository] поверх сгенерированного API-клиента
/// (MADR-007). Зеркалит `HomeRepositoryImpl` / `CareEventRepositoryImpl`.
///
/// Scope per-request: `/species` — публичный ([AuthScope.none]), `POST /plants`
/// — [AuthScope.user] (`X-User-Id` ставит `AuthInterceptor` из `AuthSession`,
/// data идентичность не знает — см. [_headerOverriddenByInterceptor]).
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class AddPlantRepositoryImpl implements AddPlantRepository {
  const AddPlantRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Заглушка обязательного `@Header`-параметра сгенерированного клиента.
  /// Реальный `X-User-Id` ставит `AuthInterceptor` и перезаписывает это
  /// значение — data-слой идентичность не знает.
  static const int _headerOverriddenByInterceptor = 0;

  @override
  Future<Result<List<SpeciesSummary>>> searchSpecies({
    String query = '',
    int limit = 20,
  }) async {
    try {
      final response = await _api.species.listSpecies(
        q: query,
        limit: limit,
        extras: authScopeExtra(AuthScope.none),
      );
      return Result.success(
        response.items.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<SpeciesDetail>> getSpeciesDetail(int id) async {
    try {
      final dto = await _api.species.getSpecies(
        id: id,
        extras: authScopeExtra(AuthScope.none),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<int>> createPlant({
    required String name,
    int? locationId,
    String? notes,
    int? speciesId,
  }) async {
    try {
      final dto = await _api.plants.createPlant(
        xUserId: _headerOverriddenByInterceptor,
        body: PlantCreateRequest(
          name: name,
          locationId: locationId,
          notes: notes,
          speciesId: speciesId,
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
