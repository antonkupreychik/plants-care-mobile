// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response_disease_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResponseDiseaseDto _$PageResponseDiseaseDtoFromJson(
  Map<String, dynamic> json,
) => PageResponseDiseaseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => DiseaseDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PageResponseDiseaseDtoToJson(
  PageResponseDiseaseDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'offset': instance.offset,
  'limit': instance.limit,
};
