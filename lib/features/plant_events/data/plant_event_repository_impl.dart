import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/plant_events_client.dart';
import '../../../core/api/generated/models/plant_event_request.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/plant_event.dart';
import '../domain/plant_event_repository.dart';
import '../domain/plant_event_type.dart';
import '../domain/plant_events_page.dart';
import 'mappers/plant_event_mapper.dart';

/// Реализация [PlantEventRepository] поверх сгенерированного [PlantEventsClient]
/// (MADR-007). Зеркалит `CareHistoryRepositoryImpl` / `CareEventRepositoryImpl`:
/// помечает [AuthScope.user] через `authScopeExtra` — заголовок `Authorization:
/// Bearer` подставит `AuthInterceptor` из текущей `AuthSession` (MADR-006/008).
/// Идентичность здесь НЕ хардкодится: см. `AuthInterceptor`.
///
/// Маппинг DTO → domain — руками в `plant_event_mapper.dart` (разбор enum по
/// `wireName` через `PlantEventType.fromWire`, не дублируем).
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class PlantEventRepositoryImpl implements PlantEventRepository {
  const PlantEventRepositoryImpl(this._client);

  final PlantEventsClient _client;

  @override
  Future<Result<PlantEventsPage>> getEvents(
    int plantId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client.getPlantEvents(
        id: plantId,
        limit: limit,
        offset: offset,
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(response.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<PlantEvent>> addEvent(
    int plantId,
    PlantEventType eventType,
  ) async {
    try {
      final dto = await _client.createPlantEvent(
        id: plantId,
        body: PlantEventRequest(eventType: plantEventTypeToDto(eventType)),
        extras: authScopeExtra(AuthScope.user),
      );
      final event = dto.toDomainOrNull();
      if (event == null) {
        // Backend подтвердил создание, но вернул тип, который domain не знает —
        // редкий forward-compat случай. Наружу не роняем: трактуем как
        // нераспознанный ответ (MADR-011).
        return const Result.failure(ApiError.unknown());
      }
      return Result.success(event);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
