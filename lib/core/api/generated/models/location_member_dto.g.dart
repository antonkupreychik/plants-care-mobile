// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationMemberDto _$LocationMemberDtoFromJson(Map<String, dynamic> json) =>
    LocationMemberDto(
      userId: (json['userId'] as num).toInt(),
      role: LocationAccessRole.fromJson(json['role'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$LocationMemberDtoToJson(LocationMemberDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };
