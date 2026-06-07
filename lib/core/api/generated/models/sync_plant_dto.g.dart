// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_plant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPlantDto _$SyncPlantDtoFromJson(Map<String, dynamic> json) => SyncPlantDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  locationId: (json['locationId'] as num).toInt(),
  archived: json['archived'] as bool,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  notes: json['notes'] as String?,
  locationName: json['locationName'] as String?,
  speciesId: (json['speciesId'] as num?)?.toInt(),
  speciesName: json['speciesName'] as String?,
  clientId: json['clientId'] as String?,
);

Map<String, dynamic> _$SyncPlantDtoToJson(SyncPlantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'notes': instance.notes,
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'speciesId': instance.speciesId,
      'speciesName': instance.speciesName,
      'archived': instance.archived,
      'clientId': instance.clientId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
