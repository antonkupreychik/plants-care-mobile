// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_invite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptInviteResponse _$AcceptInviteResponseFromJson(
  Map<String, dynamic> json,
) => AcceptInviteResponse(
  locationId: (json['locationId'] as num).toInt(),
  locationName: json['locationName'] as String,
  role: LocationAccessRole.fromJson(json['role'] as String),
);

Map<String, dynamic> _$AcceptInviteResponseToJson(
  AcceptInviteResponse instance,
) => <String, dynamic>{
  'locationId': instance.locationId,
  'locationName': instance.locationName,
  'role': instance.role,
};
