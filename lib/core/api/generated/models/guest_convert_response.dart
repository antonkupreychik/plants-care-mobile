// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'guest_convert_response_status.dart';

part 'guest_convert_response.g.dart';

/// Ответ на конвертацию гостевого аккаунта.
@JsonSerializable()
class GuestConvertResponse {
  const GuestConvertResponse({
    required this.status,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
  });
  
  factory GuestConvertResponse.fromJson(Map<String, Object?> json) => _$GuestConvertResponseFromJson(json);
  
  /// `CONVERTED` — аккаунт конвертирован немедленно (GOOGLE/APPLE), токены в ответе.
  /// `EMAIL_SENT` — magic-link отправлен (EMAIL), токены обновятся после верификации.
  ///
  final GuestConvertResponseStatus status;

  /// Новый access-JWT. Только при `status=CONVERTED`.
  final String? accessToken;

  /// Новый refresh-JWT. Только при `status=CONVERTED`.
  final String? refreshToken;

  /// Время жизни access-токена в секундах. Только при `status=CONVERTED`.
  final int? expiresIn;

  /// Тип токена. Только при `status=CONVERTED`.
  final String? tokenType;

  Map<String, Object?> toJson() => _$GuestConvertResponseToJson(this);
}
