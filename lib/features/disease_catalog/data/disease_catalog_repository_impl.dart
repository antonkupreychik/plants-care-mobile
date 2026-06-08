import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/disease.dart';
import '../domain/disease_repository.dart';
import 'mappers/disease_mapper.dart';

/// Реализация [DiseaseCatalogRepository] поверх сгенерированного `DiseasesClient`
/// (MADR-007). Эндпоинты публичного справочника — `AuthScope.none` (без
/// заголовков идентичности, как в [CatalogRepositoryImpl]).
///
/// Ошибки dio нормализует `ErrorInterceptor` → `DioException.error` содержит
/// `ApiError`; здесь разворачиваем в `Result.failure` (MADR-011).
///
/// Пагинация: `getAll` и `search` загружают до 100 записей (лимит backend)
/// за один запрос. Постраничная навигация в текущем UI не реализована —
/// этого достаточно для справочника (~20 болезней из seed).
class DiseaseCatalogRepositoryImpl implements DiseaseCatalogRepository {
  const DiseaseCatalogRepositoryImpl(this._api);

  final PlantsCareApi _api;

  static const int _defaultLimit = 100;

  @override
  Future<Result<List<Disease>>> getAll() async {
    try {
      final response = await _api.diseases.listDiseases(
        q: '',
        offset: 0,
        limit: _defaultLimit,
        extras: authScopeExtra(AuthScope.none),
      );
      return Result.success(response.toDomainList());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<List<Disease>>> search(String query) async {
    try {
      final response = await _api.diseases.listDiseases(
        q: query,
        offset: 0,
        limit: _defaultLimit,
        extras: authScopeExtra(AuthScope.none),
      );
      return Result.success(response.toDomainList());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<Disease>> getById(int id) async {
    try {
      final response = await _api.diseases.getDiseaseById(
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
