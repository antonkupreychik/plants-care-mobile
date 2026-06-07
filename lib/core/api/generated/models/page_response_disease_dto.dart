// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'disease_dto.dart';

part 'page_response_disease_dto.g.dart';

/// Постраничный ответ со списком болезней/вредителей.
@JsonSerializable()
class PageResponseDiseaseDto {
  const PageResponseDiseaseDto({
    required this.items,
    required this.total,
    required this.offset,
    required this.limit,
  });
  
  factory PageResponseDiseaseDto.fromJson(Map<String, Object?> json) => _$PageResponseDiseaseDtoFromJson(json);
  
  final List<DiseaseDto> items;

  /// Общее количество болезней (с учётом фильтра `q`).
  final int total;
  final int offset;
  final int limit;

  Map<String, Object?> toJson() => _$PageResponseDiseaseDtoToJson(this);
}
