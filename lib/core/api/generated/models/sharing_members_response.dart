// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'sharing_member_dto.dart';

part 'sharing_members_response.g.dart';

/// Обёртка над списком соухаживающих.
@JsonSerializable()
class SharingMembersResponse {
  const SharingMembersResponse({
    required this.members,
  });
  
  factory SharingMembersResponse.fromJson(Map<String, Object?> json) => _$SharingMembersResponseFromJson(json);
  
  final List<SharingMemberDto> members;

  Map<String, Object?> toJson() => _$SharingMembersResponseToJson(this);
}
