// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'telegram_start_request.g.dart';

/// Тело POST /api/v1/auth/telegram/start. Опционально: `deviceId` сейчас.
/// игнорируется сервером, тело можно не отправлять.
///
@JsonSerializable()
class TelegramStartRequest {
  const TelegramStartRequest({
    this.deviceId,
  });
  
  factory TelegramStartRequest.fromJson(Map<String, Object?> json) => _$TelegramStartRequestFromJson(json);
  
  /// Идентификатор устройства. Пока игнорируется сервером.
  final String? deviceId;

  Map<String, Object?> toJson() => _$TelegramStartRequestToJson(this);
}
