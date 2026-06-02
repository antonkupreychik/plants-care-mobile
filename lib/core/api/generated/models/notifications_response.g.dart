// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsResponse _$NotificationsResponseFromJson(
  Map<String, dynamic> json,
) => NotificationsResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$NotificationsResponseToJson(
  NotificationsResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'unreadCount': instance.unreadCount,
};
