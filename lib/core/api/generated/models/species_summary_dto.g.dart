// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeciesSummaryDto _$SpeciesSummaryDtoFromJson(Map<String, dynamic> json) =>
    SpeciesSummaryDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latinName: json['latinName'] as String?,
      wateringDays: (json['wateringDays'] as num?)?.toInt(),
      mistingDays: (json['mistingDays'] as num?)?.toInt(),
      fertilizingDays: (json['fertilizingDays'] as num?)?.toInt(),
      soilCheckDays: (json['soilCheckDays'] as num?)?.toInt(),
      careDifficulty: json['careDifficulty'] as String?,
      lightPreference: json['lightPreference'] as String?,
    );

Map<String, dynamic> _$SpeciesSummaryDtoToJson(SpeciesSummaryDto instance) =>
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
    };
