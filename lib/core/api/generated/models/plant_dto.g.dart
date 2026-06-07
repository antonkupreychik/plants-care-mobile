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
  healthInsufficientData: json['healthInsufficientData'] as bool?,
  healthScore: (json['healthScore'] as num?)?.toInt(),
  healthZone: json['healthZone'] == null
      ? null
      : PlantDtoHealthZone.fromJson(json['healthZone'] as String),
  acquiredAt: json['acquiredAt'] == null
      ? null
      : DateTime.parse(json['acquiredAt'] as String),
  inAcclimation: json['inAcclimation'] as bool?,
  acclimationUntil: json['acclimationUntil'] == null
      ? null
      : DateTime.parse(json['acclimationUntil'] as String),
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
  gifted: json['gifted'] as bool?,
  note: json['note'] as String?,
  totalCareDays: (json['totalCareDays'] as num?)?.toInt(),
  totalCareEvents: (json['totalCareEvents'] as num?)?.toInt(),
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
  'healthInsufficientData': instance.healthInsufficientData,
  'healthScore': instance.healthScore,
  'healthZone': instance.healthZone,
  'acquiredAt': instance.acquiredAt?.toIso8601String(),
  'inAcclimation': instance.inAcclimation,
  'acclimationUntil': instance.acclimationUntil?.toIso8601String(),
  'archivedAt': instance.archivedAt?.toIso8601String(),
  'gifted': instance.gifted,
  'note': instance.note,
  'totalCareDays': instance.totalCareDays,
  'totalCareEvents': instance.totalCareEvents,
};
