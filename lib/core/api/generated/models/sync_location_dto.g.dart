// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncLocationDto _$SyncLocationDtoFromJson(Map<String, dynamic> json) =>
    SyncLocationDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isDefault: json['isDefault'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      emoji: json['emoji'] as String?,
      clientId: json['clientId'] as String?,
    );

Map<String, dynamic> _$SyncLocationDtoToJson(SyncLocationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emoji': instance.emoji,
      'isDefault': instance.isDefault,
      'clientId': instance.clientId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
