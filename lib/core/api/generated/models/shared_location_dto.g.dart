// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedLocationDto _$SharedLocationDtoFromJson(Map<String, dynamic> json) =>
    SharedLocationDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      ownerUserId: (json['ownerUserId'] as num).toInt(),
      role: LocationAccessRole.fromJson(json['role'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$SharedLocationDtoToJson(SharedLocationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emoji': instance.emoji,
      'ownerUserId': instance.ownerUserId,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };
