// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) => LocationDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  defaultLocation: json['defaultLocation'] as bool,
  isActive: json['isActive'] as bool,
  emoji: json['emoji'] as String?,
  pausedUntil: json['pausedUntil'] == null
      ? null
      : DateTime.parse(json['pausedUntil'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LocationDtoToJson(LocationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emoji': instance.emoji,
      'defaultLocation': instance.defaultLocation,
      'isActive': instance.isActive,
      'pausedUntil': instance.pausedUntil?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
