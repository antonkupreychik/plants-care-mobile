// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_invite_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharingInviteCreateRequest _$SharingInviteCreateRequestFromJson(
  Map<String, dynamic> json,
) => SharingInviteCreateRequest(
  plantIds: (json['plantIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  inviteeContact: json['inviteeContact'] as String,
  canLogCare: json['canLogCare'] as bool? ?? false,
);

Map<String, dynamic> _$SharingInviteCreateRequestToJson(
  SharingInviteCreateRequest instance,
) => <String, dynamic>{
  'plantIds': instance.plantIds,
  'inviteeContact': instance.inviteeContact,
  'canLogCare': instance.canLogCare,
};
