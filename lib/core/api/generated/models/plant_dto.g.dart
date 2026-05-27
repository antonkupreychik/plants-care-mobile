// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantDto _$PlantDtoFromJson(Map<String, dynamic> json) => PlantDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  archived: json['archived'] as bool,
  notes: json['notes'] as String?,
  photoFileId: json['photoFileId'] as String?,
  locationId: (json['locationId'] as num?)?.toInt(),
  locationName: json['locationName'] as String?,
  speciesId: (json['speciesId'] as num?)?.toInt(),
  speciesName: json['speciesName'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PlantDtoToJson(PlantDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'notes': instance.notes,
  'photoFileId': instance.photoFileId,
  'locationId': instance.locationId,
  'locationName': instance.locationName,
  'speciesId': instance.speciesId,
  'speciesName': instance.speciesName,
  'archived': instance.archived,
  'createdAt': instance.createdAt?.toIso8601String(),
};
