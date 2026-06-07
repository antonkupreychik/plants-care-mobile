// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'guest_login_response.g.dart';

/// Ответ на гостевой вход (issue
@JsonSerializable()
class GuestLoginResponse {
  const GuestLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.isNewUser,
  });
  
  factory GuestLoginResponse.fromJson(Map<String, Object?> json) => _$GuestLoginResponseFromJson(json);
  
  /// Access-JWT для авторизации запросов.
  final String accessToken;

  /// Refresh-JWT для получения новой пары.
  final String refreshToken;

  /// Время жизни access-токена в секундах.
  final int expiresIn;

  /// Тип токена.
  final String tokenType;

  /// `true` — создан новый гость; `false` — восстановление по deviceId.
  final bool isNewUser;

  Map<String, Object?> toJson() => _$GuestLoginResponseToJson(this);
}
