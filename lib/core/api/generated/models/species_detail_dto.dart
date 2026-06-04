// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'species_fact_dto.dart';

part 'species_detail_dto.g.dart';

/// Полная карточка вида. Все поля `SpeciesSummaryDto` плюс `description`.
///
@JsonSerializable()
class SpeciesDetailDto {
  const SpeciesDetailDto({
    required this.id,
    required this.name,
    this.latinName,
    this.wateringDays,
    this.mistingDays,
    this.fertilizingDays,
    this.soilCheckDays,
    this.careDifficulty,
    this.lightPreference,
    this.toxicToCats,
    this.toxicToDogs,
    this.toxicToHumans,
    this.description,
    this.facts,
  });
  
  factory SpeciesDetailDto.fromJson(Map<String, Object?> json) => _$SpeciesDetailDtoFromJson(json);
  
  final int id;
  final String name;
  final String? latinName;
  final int? wateringDays;
  final int? mistingDays;
  final int? fertilizingDays;
  final int? soilCheckDays;
  final String? careDifficulty;
  final String? lightPreference;

  /// Токсично для кошек. null — данных нет.
  final bool? toxicToCats;

  /// Токсично для собак. null — данных нет.
  final bool? toxicToDogs;

  /// Токсично для человека. null — данных нет.
  final bool? toxicToHumans;

  /// Длинное текстовое описание вида.
  final String? description;

  /// Энциклопедические факты о виде (ADR-011, issue #129), отсортированы.
  /// по категории, затем по `displayOrder`. Пустой массив, если фактов нет.
  ///
  final List<SpeciesFactDto>? facts;

  Map<String, Object?> toJson() => _$SpeciesDetailDtoToJson(this);
}
