// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantHistoryResponse _$PlantHistoryResponseFromJson(
  Map<String, dynamic> json,
) => PlantHistoryResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => CareEventResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$PlantHistoryResponseToJson(
  PlantHistoryResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};
