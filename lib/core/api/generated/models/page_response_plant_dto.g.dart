// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response_plant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResponsePlantDto _$PageResponsePlantDtoFromJson(
  Map<String, dynamic> json,
) => PageResponsePlantDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => PlantDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PageResponsePlantDtoToJson(
  PageResponsePlantDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'offset': instance.offset,
  'limit': instance.limit,
};
