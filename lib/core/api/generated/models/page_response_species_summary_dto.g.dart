// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response_species_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResponseSpeciesSummaryDto _$PageResponseSpeciesSummaryDtoFromJson(
  Map<String, dynamic> json,
) => PageResponseSpeciesSummaryDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => SpeciesSummaryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PageResponseSpeciesSummaryDtoToJson(
  PageResponseSpeciesSummaryDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'offset': instance.offset,
  'limit': instance.limit,
};
