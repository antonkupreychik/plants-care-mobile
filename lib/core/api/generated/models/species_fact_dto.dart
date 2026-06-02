// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'species_fact_dto_category.dart';

part 'species_fact_dto.g.dart';

/// Один энциклопедический факт о виде (ADR-011, issue
@JsonSerializable()
class SpeciesFactDto {
  const SpeciesFactDto({
    required this.category,
    required this.body,
    this.title,
    this.source,
  });
  
  factory SpeciesFactDto.fromJson(Map<String, Object?> json) => _$SpeciesFactDtoFromJson(json);
  
  /// Категория факта.
  final SpeciesFactDtoCategory category;

  /// Опциональный заголовок факта.
  final String? title;

  /// Текст факта.
  final String body;

  /// Опциональная ссылка/атрибуция источника.
  final String? source;

  Map<String, Object?> toJson() => _$SpeciesFactDtoToJson(this);
}
