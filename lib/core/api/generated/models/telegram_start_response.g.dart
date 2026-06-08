// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_start_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TelegramStartResponse _$TelegramStartResponseFromJson(
  Map<String, dynamic> json,
) => TelegramStartResponse(
  sessionId: json['sessionId'] as String,
  deepLink: json['deepLink'] as String,
  codeLength: (json['codeLength'] as num).toInt(),
  resendAfterSec: (json['resendAfterSec'] as num).toInt(),
);

Map<String, dynamic> _$TelegramStartResponseToJson(
  TelegramStartResponse instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'deepLink': instance.deepLink,
  'codeLength': instance.codeLength,
  'resendAfterSec': instance.resendAfterSec,
};
