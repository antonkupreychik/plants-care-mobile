// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_invite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationInviteResponse _$LocationInviteResponseFromJson(
  Map<String, dynamic> json,
) => LocationInviteResponse(
  token: json['token'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$LocationInviteResponseToJson(
  LocationInviteResponse instance,
) => <String, dynamic>{
  'token': instance.token,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
