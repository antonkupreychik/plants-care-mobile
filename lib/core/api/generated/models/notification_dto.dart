// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'notification_dto_type.dart';

part 'notification_dto.g.dart';

/// Уведомление в ленте пользователя.
@JsonSerializable()
class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.plantId,
    this.readAt,
  });
  
  factory NotificationDto.fromJson(Map<String, Object?> json) => _$NotificationDtoFromJson(json);
  
  final int id;

  /// Тип уведомления.
  final NotificationDtoType type;
  final String title;
  final String body;

  /// Ссылка на растение для deep-link; null, если уведомление не привязано.
  final int? plantId;

  /// Момент создания в UTC.
  final DateTime createdAt;

  /// Момент прочтения в UTC; null = непрочитано.
  final DateTime? readAt;

  Map<String, Object?> toJson() => _$NotificationDtoToJson(this);
}
