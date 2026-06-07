// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'location_member_dto.dart';

part 'location_members_response.g.dart';

@JsonSerializable()
class LocationMembersResponse {
  const LocationMembersResponse({
    required this.members,
  });
  
  factory LocationMembersResponse.fromJson(Map<String, Object?> json) => _$LocationMembersResponseFromJson(json);
  
  final List<LocationMemberDto> members;

  Map<String, Object?> toJson() => _$LocationMembersResponseToJson(this);
}
