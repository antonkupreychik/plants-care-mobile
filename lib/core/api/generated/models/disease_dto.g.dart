// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiseaseDto _$DiseaseDtoFromJson(Map<String, dynamic> json) => DiseaseDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  symptoms: json['symptoms'] as String,
  treatment: json['treatment'] as String,
  prevention: json['prevention'] as String,
  latinName: json['latinName'] as String?,
);

Map<String, dynamic> _$DiseaseDtoToJson(DiseaseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latinName': instance.latinName,
      'symptoms': instance.symptoms,
      'treatment': instance.treatment,
      'prevention': instance.prevention,
    };
