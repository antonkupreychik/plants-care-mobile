import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/catalog_repository.dart';
import '../domain/species_detail.dart';
import '../domain/species_page.dart';
import 'mappers/species_mapper.dart';

/// Реализация [CatalogRepository] поверх сгенерированного клиента `SpeciesClient`
/// (MADR-007). Оба эндпоинта публичные — на каждый запрос проставляем
/// `AuthScope.none` через `authScopeExtra` (интерсептор не вешает заголовок
/// идентичности). Идентичность здесь не нужна и не хардкодится.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в `DioException.error`;
/// здесь это разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<SpeciesPage>> searchSpecies({
    required String query,
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _api.species.listSpecies(
        q: query,
        offset: offset,
        limit: limit,
        extras: authScopeExtra(AuthScope.none),
      );
      return Result.success(response.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<SpeciesDetail>> getSpecies(int id) async {
    try {
      final response = await _api.species.getSpecies(
        id: id,
        extras: authScopeExtra(AuthScope.none),
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
