// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'species_summary_dto.g.dart';

/// Краткая карточка вида для списка.
@JsonSerializable()
class SpeciesSummaryDto {
  const SpeciesSummaryDto({
    required this.id,
    required this.name,
    this.latinName,
    this.wateringDays,
    this.mistingDays,
    this.fertilizingDays,
    this.soilCheckDays,
    this.careDifficulty,
    this.lightPreference,
  });
  
  factory SpeciesSummaryDto.fromJson(Map<String, Object?> json) => _$SpeciesSummaryDtoFromJson(json);
  
  final int id;
  final String name;
  final String? latinName;

  /// Рекомендуемый интервал полива в днях.
  final int? wateringDays;
  final int? mistingDays;
  final int? fertilizingDays;
  final int? soilCheckDays;

  /// Имя enum'а `CareDifficulty.name()`.
  final String? careDifficulty;

  /// Имя enum'а `LightPreference.name()`.
  final String? lightPreference;

  Map<String, Object?> toJson() => _$SpeciesSummaryDtoToJson(this);
}
