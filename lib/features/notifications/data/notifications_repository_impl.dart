import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/notification_feed.dart';
import '../domain/notifications_repository.dart';
import 'mappers/notification_mapper.dart';

/// Реализация [NotificationsRepository] поверх сгенерированного API-клиента
/// (MADR-007), зеркалит `CareHistoryRepositoryImpl`. Оба эндпоинта помечают
/// [AuthScope.user] — `AuthInterceptor` подставит `Authorization: Bearer` из
/// текущей `AuthSession` (MADR-008); backend резолвит пользователя из `sub`.
/// Идентичность здесь НЕ хардкодится.
///
/// Только сеть, без локального кеша: листовая фича `care_history` тоже без
/// drift (см. отчёт). Ошибки dio `ErrorInterceptor` нормализует в [ApiError]
/// и кладёт в `DioException.error`; здесь разворачиваем в `Result.failure`
/// (MADR-011), наружу не бросаем.
class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<NotificationFeed>> getFeed({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _api.notifications.listNotifications(
        limit: limit,
        offset: offset,
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(
        NotificationFeed(
          items: response.items
              .map((dto) => dto.toDomain())
              .toList(growable: false),
          unreadCount: response.unreadCount,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> markRead(int id) async {
    try {
      await _api.notifications.markNotificationRead(
        id: id,
        extras: authScopeExtra(AuthScope.user),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
