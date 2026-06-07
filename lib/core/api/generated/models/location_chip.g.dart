// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_chip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationChip _$LocationChipFromJson(Map<String, dynamic> json) => LocationChip(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$LocationChipToJson(LocationChip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'emoji': instance.emoji,
    };
