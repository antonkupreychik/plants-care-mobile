// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeciesDetailDto _$SpeciesDetailDtoFromJson(Map<String, dynamic> json) =>
    SpeciesDetailDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latinName: json['latinName'] as String?,
      wateringDays: (json['wateringDays'] as num?)?.toInt(),
      mistingDays: (json['mistingDays'] as num?)?.toInt(),
      fertilizingDays: (json['fertilizingDays'] as num?)?.toInt(),
      soilCheckDays: (json['soilCheckDays'] as num?)?.toInt(),
      careDifficulty: json['careDifficulty'] as String?,
      lightPreference: json['lightPreference'] as String?,
      description: json['description'] as String?,
      facts: (json['facts'] as List<dynamic>?)
          ?.map((e) => SpeciesFactDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpeciesDetailDtoToJson(SpeciesDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latinName': instance.latinName,
      'wateringDays': instance.wateringDays,
      'mistingDays': instance.mistingDays,
      'fertilizingDays': instance.fertilizingDays,
      'soilCheckDays': instance.soilCheckDays,
      'careDifficulty': instance.careDifficulty,
      'lightPreference': instance.lightPreference,
      'description': instance.description,
      'facts': instance.facts,
    };
