// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'telegram_verify_request.g.dart';

/// Тело POST /api/v1/auth/telegram/verify. `telegram_chat_id` сервер берёт из.
/// сессии и НЕ принимает от клиента.
///
@JsonSerializable()
class TelegramVerifyRequest {
  const TelegramVerifyRequest({
    required this.sessionId,
    required this.code,
  });
  
  factory TelegramVerifyRequest.fromJson(Map<String, Object?> json) => _$TelegramVerifyRequestFromJson(json);
  
  /// Идентификатор сессии входа из ответа telegram/start.
  final String sessionId;

  /// Код подтверждения, присланный ботом.
  final String code;

  Map<String, Object?> toJson() => _$TelegramVerifyRequestToJson(this);
}
