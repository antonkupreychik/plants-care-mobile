// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'species_fact_dto.g.dart';

/// Один справочный факт о виде. `category` — открытый перечень строк.
/// (`CARE` | `CURIOSITY` | `ORIGIN` | `TOXICITY` | …), клиент нормализует.
/// в domain-enum и схлопывает неизвестное в `unknown`.
///
@JsonSerializable()
class SpeciesFactDto {
  const SpeciesFactDto({
    required this.category,
    required this.title,
    required this.body,
    this.source,
  });
  
  factory SpeciesFactDto.fromJson(Map<String, Object?> json) => _$SpeciesFactDtoFromJson(json);
  
  /// Код категории факта, напр. `TOXICITY`.
  final String category;
  final String title;

  /// Текст факта.
  final String body;

  /// Источник факта (напр. `ASPCA`), если указан.
  final String? source;

  Map<String, Object?> toJson() => _$SpeciesFactDtoToJson(this);
}
