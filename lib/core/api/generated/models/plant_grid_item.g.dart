// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_grid_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantGridItem _$PlantGridItemFromJson(Map<String, dynamic> json) =>
    PlantGridItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      locationName: json['locationName'] as String?,
      action: json['action'] == null
          ? null
          : ActionDescriptor.fromJson(json['action'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlantGridItemToJson(PlantGridItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locationName': instance.locationName,
      'action': instance.action,
    };
