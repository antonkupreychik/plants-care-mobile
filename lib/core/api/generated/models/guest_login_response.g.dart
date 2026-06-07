// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestLoginResponse _$GuestLoginResponseFromJson(Map<String, dynamic> json) =>
    GuestLoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      tokenType: json['tokenType'] as String,
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$GuestLoginResponseToJson(GuestLoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'tokenType': instance.tokenType,
      'isNewUser': instance.isNewUser,
    };
