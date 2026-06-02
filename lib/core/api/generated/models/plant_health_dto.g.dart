// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_health_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantHealthDto _$PlantHealthDtoFromJson(Map<String, dynamic> json) =>
    PlantHealthDto(
      insufficientData: json['insufficientData'] as bool,
      score: (json['score'] as num?)?.toInt(),
      zone: json['zone'] == null
          ? null
          : PlantHealthDtoZone.fromJson(json['zone'] as String),
    );

Map<String, dynamic> _$PlantHealthDtoToJson(PlantHealthDto instance) =>
    <String, dynamic>{
      'insufficientData': instance.insufficientData,
      'score': instance.score,
      'zone': instance.zone,
    };
