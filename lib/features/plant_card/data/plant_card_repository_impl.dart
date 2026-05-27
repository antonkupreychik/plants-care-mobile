import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../../home/data/mappers/plant_mapper.dart';
import '../../home/domain/plant.dart';
import '../domain/care_history_entry.dart';
import '../domain/plant_card_repository.dart';
import '../domain/streak.dart';
import 'mappers/care_history_mapper.dart';
import 'mappers/streak_mapper.dart';

/// Реализация [PlantCardRepository] поверх сгенерированного API-клиента
/// (MADR-007). Зеркалит [HomeRepositoryImpl]: три независимых чтения, каждое
/// помечает [AuthScope] через `authScopeExtra` — нужный заголовок
/// (`X-User-Id` / `X-Chat-Id`) подставит `AuthInterceptor` из текущей
/// `AuthSession` (MADR-006/008). Идентичность здесь НЕ хардкодится:
/// см. [_headerOverriddenByInterceptor].
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
///
/// `PlantDto` → [Plant] переиспользует `PlantDtoMapper` из data-слоя фичи
/// `home` (та же модель, тот же DTO) — не дублируем маппинг.
class PlantCardRepositoryImpl implements PlantCardRepository {
  const PlantCardRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Заглушка обязательного `@Header`-параметра сгенерированного клиента.
  /// Реальный заголовок ставит `AuthInterceptor` из `AuthSession` и
  /// перезаписывает это значение — data-слой идентичность не знает.
  static const int _headerOverriddenByInterceptor = 0;

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

  @override
  Future<Result<List<CareHistoryEntry>>> getHistory(
    int plantId, {
    int limit = 10,
  }) async {
    try {
      final response = await _api.plantHistory.getPlantHistory(
        xChatId: _headerOverriddenByInterceptor,
        id: plantId,
        limit: limit,
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(
        response.items.map((dto) => dto.toDomain()).toList(growable: false),
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

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
