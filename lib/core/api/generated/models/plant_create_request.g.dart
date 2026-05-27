// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantCreateRequest _$PlantCreateRequestFromJson(Map<String, dynamic> json) =>
    PlantCreateRequest(
      name: json['name'] as String,
      notes: json['notes'] as String?,
      locationId: (json['locationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlantCreateRequestToJson(PlantCreateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'notes': instance.notes,
      'locationId': instance.locationId,
    };
