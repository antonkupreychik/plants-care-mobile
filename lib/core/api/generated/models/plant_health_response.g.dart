// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_health_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantHealthResponse _$PlantHealthResponseFromJson(Map<String, dynamic> json) =>
    PlantHealthResponse(
      insufficientData: json['insufficientData'] as bool,
      score: (json['score'] as num?)?.toInt(),
      zone: json['zone'] == null
          ? null
          : PlantHealthResponseZone.fromJson(json['zone'] as String),
    );

Map<String, dynamic> _$PlantHealthResponseToJson(
  PlantHealthResponse instance,
) => <String, dynamic>{
  'insufficientData': instance.insufficientData,
  'score': instance.score,
  'zone': instance.zone,
};
