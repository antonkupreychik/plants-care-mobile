// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'telegram_start_response.g.dart';

/// Ответ POST /api/v1/auth/telegram/start (issue
@JsonSerializable()
class TelegramStartResponse {
  const TelegramStartResponse({
    required this.sessionId,
    required this.deepLink,
    required this.codeLength,
    required this.resendAfterSec,
  });
  
  factory TelegramStartResponse.fromJson(Map<String, Object?> json) => _$TelegramStartResponseFromJson(json);
  
  /// Идентификатор сессии входа. Передаётся обратно в telegram/verify.
  final String sessionId;

  /// Ссылка на Telegram-бота вида `t.me/<botUsername>?start=auth_<sessionId>`.
  ///
  final String deepLink;

  /// Длина кода подтверждения, который пришлёт бот.
  final int codeLength;

  /// Через сколько секунд можно повторно запросить код.
  final int resendAfterSec;

  Map<String, Object?> toJson() => _$TelegramStartResponseToJson(this);
}
