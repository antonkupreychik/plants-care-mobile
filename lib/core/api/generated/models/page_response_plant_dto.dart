// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_dto.dart';

part 'page_response_plant_dto.g.dart';

/// Постраничный ответ со списком растений.
@JsonSerializable()
class PageResponsePlantDto {
  const PageResponsePlantDto({
    required this.items,
    required this.total,
    required this.offset,
    required this.limit,
  });
  
  factory PageResponsePlantDto.fromJson(Map<String, Object?> json) => _$PageResponsePlantDtoFromJson(json);
  
  /// Растения на текущей странице.
  final List<PlantDto> items;

  /// Общее количество растений, удовлетворяющих фильтру.
  final int total;
  final int offset;
  final int limit;

  Map<String, Object?> toJson() => _$PageResponsePlantDtoToJson(this);
}
