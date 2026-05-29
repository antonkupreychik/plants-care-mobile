import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/care_event_draft.dart';
import '../domain/care_event_repository.dart';
import '../domain/logged_care_event.dart';
import 'mappers/care_event_mapper.dart';

/// Реализация [CareEventRepository] поверх сгенерированного API-клиента
/// (MADR-007). Зеркалит `HomeRepositoryImpl` / `PlantCardRepositoryImpl`:
/// помечает [AuthScope.chat] через `authScopeExtra` — заголовок `X-Chat-Id`
/// подставит `AuthInterceptor` из текущей `AuthSession` (MADR-006/008).
/// Идентичность здесь НЕ хардкодится: см. [_headerOverriddenByInterceptor].
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class CareEventRepositoryImpl implements CareEventRepository {
  const CareEventRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Заглушка обязательного `@Header`-параметра сгенерированного клиента.
  /// Реальный `X-Chat-Id` ставит `AuthInterceptor` из `AuthSession` и
  /// перезаписывает это значение — data-слой идентичность не знает.
  static const int _headerOverriddenByInterceptor = 0;

  @override
  Future<Result<LoggedCareEvent>> logCareEvent(CareEventDraft draft) async {
    // Валидация типа до сети: unknown/SOIL_CHECK не отправляемы (api-contract §7).
    final dtoType = careEventTypeFromKind(draft.type);
    if (dtoType == null) {
      return const Result.failure(
        ApiError.badRequest(message: 'Недоступный тип ухода'),
      );
    }

    try {
      final response = await _api.careEvents.createCareEvent(
        xChatId: _headerOverriddenByInterceptor,
        body: draft.toRequest(dtoType),
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(response.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<int>> priorCareEventCount(int plantId) async {
    try {
      // Минимальная страница: нужны только метаданные пагинации (`total`),
      // сами записи не загружаем. Тот же эндпоинт и scope chat, что у чтения
      // истории в `PlantCardRepositoryImpl.getHistory` (`X-Chat-Id` ставит
      // `AuthInterceptor`). Держим вызов в фиче care_event, чтобы детекция
      // «первого ухода» была самодостаточной.
      final response = await _api.plantHistory.getPlantHistory(
        xChatId: _headerOverriddenByInterceptor,
        id: plantId,
        limit: 1,
        offset: 0,
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(response.total);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
