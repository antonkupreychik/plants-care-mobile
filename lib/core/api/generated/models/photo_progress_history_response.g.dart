// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_progress_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoProgressHistoryResponse _$PhotoProgressHistoryResponseFromJson(
  Map<String, dynamic> json,
) => PhotoProgressHistoryResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => PhotoProgressItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$PhotoProgressHistoryResponseToJson(
  PhotoProgressHistoryResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};
