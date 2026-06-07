// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'location_access_role.dart';

part 'location_member_dto.g.dart';

/// Участник локации (Subject + role).
@JsonSerializable()
class LocationMemberDto {
  const LocationMemberDto({
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.displayName,
  });
  
  factory LocationMemberDto.fromJson(Map<String, Object?> json) => _$LocationMemberDtoFromJson(json);
  
  /// Идентификатор пользователя.
  final int userId;

  /// Отображаемое имя пользователя (username или email).
  final String? displayName;
  final LocationAccessRole role;

  /// Когда появился доступ (UTC).
  final DateTime joinedAt;

  Map<String, Object?> toJson() => _$LocationMemberDtoToJson(this);
}
