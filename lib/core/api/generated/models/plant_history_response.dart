// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_event_response.dart';

part 'plant_history_response.g.dart';

/// Страница истории ухода за растением с метаданными пагинации.
@JsonSerializable()
class PlantHistoryResponse {
  const PlantHistoryResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });
  
  factory PlantHistoryResponse.fromJson(Map<String, Object?> json) => _$PlantHistoryResponseFromJson(json);
  
  final List<CareEventResponse> items;

  /// Общее количество активных записей.
  final int total;
  final int limit;
  final int offset;

  Map<String, Object?> toJson() => _$PlantHistoryResponseToJson(this);
}
