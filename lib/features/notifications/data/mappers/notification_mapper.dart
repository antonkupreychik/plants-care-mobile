import '../../../../core/api/generated/models/notification_dto.dart';
import '../../../../core/api/generated/models/notification_dto_type.dart';
import '../../domain/notification_item.dart';
import '../../domain/notification_type.dart';

/// Маппинг [NotificationDto] (`/api/v1/notifications`) → domain
/// [NotificationItem] (MADR-002). Точка нормализации контракта.
extension NotificationDtoMapper on NotificationDto {
  NotificationItem toDomain() => NotificationItem(
        id: id,
        type: type.toDomain(),
        title: title,
        body: body,
        createdAt: createdAt,
        readAt: readAt,
        plantId: plantId,
      );
}

/// Маппинг сгенерированного enum [NotificationDtoType] → domain
/// [NotificationType], 1:1 по известным значениям. Нераспознанный код
/// (`$unknown` — контракт мог добавить тип) схлопывается в безопасный
/// [NotificationType.system]: лента не падает, UI рисует нейтрально.
extension on NotificationDtoType {
  NotificationType toDomain() => switch (this) {
        NotificationDtoType.care => NotificationType.care,
        NotificationDtoType.alert => NotificationType.alert,
        NotificationDtoType.award => NotificationType.award,
        NotificationDtoType.report => NotificationType.report,
        NotificationDtoType.system => NotificationType.system,
        NotificationDtoType.$unknown => NotificationType.system,
      };
}
