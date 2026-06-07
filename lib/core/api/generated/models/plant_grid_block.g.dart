// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_grid_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantGridBlock _$PlantGridBlockFromJson(Map<String, dynamic> json) =>
    PlantGridBlock(
      type: PlantGridBlockType.fromJson(json['type'] as String),
      plants: (json['plants'] as List<dynamic>)
          .map((e) => PlantGridItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlantGridBlockToJson(PlantGridBlock instance) =>
    <String, dynamic>{'type': instance.type, 'plants': instance.plants};
