import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_type.dart';

part 'notification_item.freezed.dart';

/// Одно уведомление ленты (экран 24), источник — `NotificationDto`
/// (`GET /api/v1/notifications`). Чистый Dart, иммутабельно.
///
/// [readAt] — момент прочтения (UTC) или `null` (непрочитано); производный
/// флаг [isRead] выводится из него. Маппинг DTO → domain делает
/// `NotificationDtoMapper` (MADR-002). [createdAt] backend отдаёт в UTC —
/// группировку по дням в локальной таймзоне делает UI (`createdAt.toLocal()`),
/// не эта модель.
@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    /// Идентификатор уведомления (для `markRead`).
    required int id,

    /// Тип (иконка/акцент в UI).
    required NotificationType type,

    /// Заголовок «голосом растения» (с backend).
    required String title,

    /// Тело «голосом растения» (с backend).
    required String body,

    /// Момент создания в UTC (UI приводит к локали для группировки по дням).
    required DateTime createdAt,

    /// Момент прочтения в UTC; `null` — непрочитано.
    DateTime? readAt,

    /// Ссылка на растение для deep-link; `null`, если не привязано.
    int? plantId,
  }) = _NotificationItem;

  const NotificationItem._();

  /// Прочитано ли уведомление (производное от `readAt != null`).
  bool get isRead => readAt != null;
}
