// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'location_invite_response.g.dart';

/// Результат создания приглашения.
@JsonSerializable()
class LocationInviteResponse {
  const LocationInviteResponse({
    required this.token,
    required this.expiresAt,
  });
  
  factory LocationInviteResponse.fromJson(Map<String, Object?> json) => _$LocationInviteResponseFromJson(json);
  
  /// Одноразовый токен приглашения.
  final String token;

  /// Когда токен истекает (UTC).
  final DateTime expiresAt;

  Map<String, Object?> toJson() => _$LocationInviteResponseToJson(this);
}
