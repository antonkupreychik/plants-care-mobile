// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_convert_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestConvertResponse _$GuestConvertResponseFromJson(
  Map<String, dynamic> json,
) => GuestConvertResponse(
  status: GuestConvertResponseStatus.fromJson(json['status'] as String),
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
  expiresIn: (json['expiresIn'] as num?)?.toInt(),
  tokenType: json['tokenType'] as String?,
);

Map<String, dynamic> _$GuestConvertResponseToJson(
  GuestConvertResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresIn': instance.expiresIn,
  'tokenType': instance.tokenType,
};
