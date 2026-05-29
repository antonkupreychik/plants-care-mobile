// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_fact_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeciesFactDto _$SpeciesFactDtoFromJson(Map<String, dynamic> json) =>
    SpeciesFactDto(
      category: json['category'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$SpeciesFactDtoToJson(SpeciesFactDto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'title': instance.title,
      'body': instance.body,
      'source': instance.source,
    };
