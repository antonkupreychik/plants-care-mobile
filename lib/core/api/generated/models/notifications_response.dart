// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'notification_dto.dart';

part 'notifications_response.g.dart';

/// Лента уведомлений со счётчиком непрочитанных.
@JsonSerializable()
class NotificationsResponse {
  const NotificationsResponse({
    required this.items,
    required this.unreadCount,
  });
  
  factory NotificationsResponse.fromJson(Map<String, Object?> json) => _$NotificationsResponseFromJson(json);
  
  final List<NotificationDto> items;

  /// Количество непрочитанных уведомлений пользователя.
  final int unreadCount;

  Map<String, Object?> toJson() => _$NotificationsResponseToJson(this);
}
