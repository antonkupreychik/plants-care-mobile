// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_pair_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPairResponse _$TokenPairResponseFromJson(Map<String, dynamic> json) =>
    TokenPairResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$TokenPairResponseToJson(TokenPairResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'tokenType': instance.tokenType,
    };
