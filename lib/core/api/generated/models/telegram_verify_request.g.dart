// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TelegramVerifyRequest _$TelegramVerifyRequestFromJson(
  Map<String, dynamic> json,
) => TelegramVerifyRequest(
  sessionId: json['sessionId'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$TelegramVerifyRequestToJson(
  TelegramVerifyRequest instance,
) => <String, dynamic>{'sessionId': instance.sessionId, 'code': instance.code};
