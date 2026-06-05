// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharingMembersResponse _$SharingMembersResponseFromJson(
  Map<String, dynamic> json,
) => SharingMembersResponse(
  members: (json['members'] as List<dynamic>)
      .map((e) => SharingMemberDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SharingMembersResponseToJson(
  SharingMembersResponse instance,
) => <String, dynamic>{'members': instance.members};
