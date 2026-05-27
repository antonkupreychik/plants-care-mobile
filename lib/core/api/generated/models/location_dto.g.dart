// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) => LocationDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  defaultLocation: json['defaultLocation'] as bool,
  emoji: json['emoji'] as String?,
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
      'createdAt': instance.createdAt?.toIso8601String(),
    };
