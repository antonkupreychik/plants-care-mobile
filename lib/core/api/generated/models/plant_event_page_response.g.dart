// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_event_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantEventPageResponse _$PlantEventPageResponseFromJson(
  Map<String, dynamic> json,
) => PlantEventPageResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => PlantEventDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$PlantEventPageResponseToJson(
  PlantEventPageResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};
