// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_chips_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationChipsBlock _$LocationChipsBlockFromJson(Map<String, dynamic> json) =>
    LocationChipsBlock(
      type: LocationChipsBlockType.fromJson(json['type'] as String),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => LocationChip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationChipsBlockToJson(LocationChipsBlock instance) =>
    <String, dynamic>{'type': instance.type, 'locations': instance.locations};
