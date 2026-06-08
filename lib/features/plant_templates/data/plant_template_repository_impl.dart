import 'package:dio/dio.dart';

import '../../../core/api/generated/models/plant_template_create_request.dart';
import '../../../core/api/generated/models/plant_template_instantiate_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../../home/data/mappers/plant_mapper.dart';
import '../../home/domain/plant.dart';
import '../domain/plant_template.dart';
import '../domain/plant_template_repository.dart';
import 'mappers/plant_template_mapper.dart';

/// Реализация [PlantTemplateRepository] поверх сгенерированного
/// `PlantTemplatesClient` (MADR-007).
///
/// Все эндпоинты `/api/v1/plant-templates` принадлежат пользователю →
/// [AuthScope.user] на каждый запрос. Заголовок подставит `AuthInterceptor`
/// из текущей `AuthSession` (MADR-006/008); идентичность здесь НЕ хардкодится.
///
/// Ошибки dio ловит `ErrorInterceptor` → `DioException.error: ApiError`;
/// здесь разворачиваем в `Result.failure` (MADR-011), наружу не бросаем.
class PlantTemplateRepositoryImpl implements PlantTemplateRepository {
  const PlantTemplateRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<List<PlantTemplate>>> getTemplates() async {
    try {
      final dtos = await _api.plantTemplates.listPlantTemplates(
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(
        dtos.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<PlantTemplate>> createTemplate({
    required String name,
    int? fromPlantId,
  }) async {
    try {
      final dto = await _api.plantTemplates.createPlantTemplate(
        body: PlantTemplateCreateRequest(name: name, fromPlantId: fromPlantId),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> deleteTemplate(int id) async {
    try {
      await _api.plantTemplates.deletePlantTemplate(
        id: id,
        extras: authScopeExtra(AuthScope.user),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<Plant>> instantiateTemplate({
    required int templateId,
    required String plantName,
  }) async {
    try {
      final dto = await _api.plantTemplates.instantiatePlantTemplate(
        id: templateId,
        body: PlantTemplateInstantiateRequest(name: plantName),
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
