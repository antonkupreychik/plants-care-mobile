// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notifications_response.dart';

part 'notifications_client.g.dart';

@RestApi()
abstract class NotificationsClient {
  factory NotificationsClient(Dio dio, {String? baseUrl}) = _NotificationsClient;

  /// Лента уведомлений пользователя.
  ///
  /// Возвращает страницу уведомлений текущего пользователя (`sub` из.
  /// bearer-токена), новые сверху (по `createdAt` DESC), плюс счётчик.
  /// непрочитанных `unreadCount`.
  ///
  /// `createdAt`/`readAt` — UTC (`date-time`); клиент группирует по дням в.
  /// таймзоне пользователя. Пагинация — `offset`/`limit`:.
  /// * `limit` — в диапазоне **[1, 100]**; значение вне диапазона → `400`;.
  /// * `offset` — **≥ 0**; отрицательное значение → `400`.
  ///
  /// [offset] - Сдвиг от начала выборки (≥ 0). Отрицательное значение → 400.
  ///
  /// [limit] - Размер страницы, [1, 100]. Значение вне диапазона → 400.
  @GET('/api/v1/notifications')
  Future<NotificationsResponse> listNotifications({
    @Query('offset') int? offset = 0,
    @Query('limit') int? limit = 20,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Пометить уведомление прочитанным.
  ///
  /// Идемпотентно помечает уведомление прочитанным. Повторный вызов.
  /// безопасен (no-op, момент первого прочтения не перезаписывается).
  /// Чужое или несуществующее уведомление — 404.
  ///
  /// [id] - Идентификатор уведомления.
  @POST('/api/v1/notifications/{id}/read')
  Future<void> markNotificationRead({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
