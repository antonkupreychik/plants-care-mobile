import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../../home/data/mappers/plant_mapper.dart';
import '../../home/domain/plant.dart';
import '../../plant_card/data/mappers/care_history_mapper.dart';
import '../../plant_card/data/mappers/streak_mapper.dart';
import '../../plant_card/domain/streak.dart';
import '../domain/care_history_page.dart';
import '../domain/care_history_repository.dart';

/// Реализация [CareHistoryRepository] поверх сгенерированного API-клиента
/// (MADR-007). Зеркалит `PlantCardRepositoryImpl`: три независимых чтения,
/// каждое помечает [AuthScope] через `authScopeExtra` — нужный заголовок
/// (`X-User-Id` / `X-Chat-Id`) подставит `AuthInterceptor` из текущей
/// `AuthSession` (MADR-006/008). Идентичность здесь НЕ хардкодится: см.
/// [_headerOverriddenByInterceptor].
///
/// Маппинг DTO ↔ domain переиспользует существующие мапперы соседних фич
/// (не дублируем): `CareEventResponseMapper.toDomain()`,
/// `StreakResponseMapper.toDomain()`, `PlantDtoMapper.toDomain()`.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class CareHistoryRepositoryImpl implements CareHistoryRepository {
  const CareHistoryRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Заглушка обязательного `@Header`-параметра сгенерированного клиента.
  /// Реальный заголовок ставит `AuthInterceptor` из `AuthSession` и
  /// перезаписывает это значение — data-слой идентичность не знает.
  static const int _headerOverriddenByInterceptor = 0;

  @override
  Future<Result<CareHistoryPage>> getHistoryPage(
    int plantId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _api.plantHistory.getPlantHistory(
        xChatId: _headerOverriddenByInterceptor,
        id: plantId,
        limit: limit,
        offset: offset,
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(
        CareHistoryPage(
          items: response.items
              .map((dto) => dto.toDomain())
              .toList(growable: false),
          total: response.total,
          limit: response.limit,
          offset: response.offset,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<Streak>> getStreak(int plantId) async {
    try {
      final response = await _api.stats.getPlantStreak(
        xChatId: _headerOverriddenByInterceptor,
        plantId: plantId,
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(response.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<Plant>> getPlant(int plantId) async {
    try {
      final dto = await _api.plants.getPlant(
        xUserId: _headerOverriddenByInterceptor,
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
