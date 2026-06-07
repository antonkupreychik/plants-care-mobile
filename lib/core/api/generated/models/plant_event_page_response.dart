// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_event_dto.dart';

part 'plant_event_page_response.g.dart';

/// Страница журнала событий растения с метаданными пагинации.
@JsonSerializable()
class PlantEventPageResponse {
  const PlantEventPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });
  
  factory PlantEventPageResponse.fromJson(Map<String, Object?> json) => _$PlantEventPageResponseFromJson(json);
  
  final List<PlantEventDto> items;

  /// Общее количество событий растения.
  final int total;
  final int limit;
  final int offset;

  Map<String, Object?> toJson() => _$PlantEventPageResponseToJson(this);
}
