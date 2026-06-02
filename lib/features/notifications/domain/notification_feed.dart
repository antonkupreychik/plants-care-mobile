import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_item.dart';

part 'notification_feed.freezed.dart';

/// Одна страница ленты уведомлений (источник — `GET /api/v1/notifications`,
/// `NotificationsResponse`).
///
/// Чистый Dart. Несёт записи страницы ([items], новые сверху — порядок backend,
/// клиент его не меняет) и счётчик непрочитанных по всему пользователю
/// ([unreadCount]) — он считается backend, не выводится из [items] (страница
/// может не содержать всех непрочитанных). Накопление страниц делает
/// presentation (`NotificationsController`), не эта модель.
///
/// Backend пагинирует через `offset`/`limit` (см. `NotificationsClient`), но в
/// ответе echo пагинации нет — поэтому здесь только [items] и [unreadCount];
/// «есть ли ещё» presentation выводит из размера последней страницы.
@freezed
abstract class NotificationFeed with _$NotificationFeed {
  const factory NotificationFeed({
    /// Записи этой страницы, новые сверху (порядок backend).
    required List<NotificationItem> items,

    /// Количество непрочитанных уведомлений пользователя (по всем страницам).
    required int unreadCount,
  }) = _NotificationFeed;

  const NotificationFeed._();
}
