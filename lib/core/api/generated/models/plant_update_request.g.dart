// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantUpdateRequest _$PlantUpdateRequestFromJson(Map<String, dynamic> json) =>
    PlantUpdateRequest(
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      locationId: (json['locationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlantUpdateRequestToJson(PlantUpdateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'notes': instance.notes,
      'locationId': instance.locationId,
    };
