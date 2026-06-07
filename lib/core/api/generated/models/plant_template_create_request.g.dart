// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_template_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantTemplateCreateRequest _$PlantTemplateCreateRequestFromJson(
  Map<String, dynamic> json,
) => PlantTemplateCreateRequest(
  name: json['name'] as String,
  fromPlantId: (json['fromPlantId'] as num?)?.toInt(),
);

Map<String, dynamic> _$PlantTemplateCreateRequestToJson(
  PlantTemplateCreateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'fromPlantId': instance.fromPlantId,
};
