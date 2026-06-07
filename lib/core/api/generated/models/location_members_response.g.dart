// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationMembersResponse _$LocationMembersResponseFromJson(
  Map<String, dynamic> json,
) => LocationMembersResponse(
  members: (json['members'] as List<dynamic>)
      .map((e) => LocationMemberDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LocationMembersResponseToJson(
  LocationMembersResponse instance,
) => <String, dynamic>{'members': instance.members};
