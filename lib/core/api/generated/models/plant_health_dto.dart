// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_health_dto_zone.dart';

part 'plant_health_dto.g.dart';

/// Health-score растения (mobile gap G1). При `insufficientData = true`.
/// поля `score` и `zone` равны `null`.
///
@JsonSerializable()
class PlantHealthDto {
  const PlantHealthDto({
    required this.insufficientData,
    this.score,
    this.zone,
  });
  
  factory PlantHealthDto.fromJson(Map<String, Object?> json) => _$PlantHealthDtoFromJson(json);
  
  /// `true` — данных мало (`< 3` активных записей ухода), балл не.
  /// вычислялся; `score`/`zone` будут `null`.
  ///
  final bool insufficientData;

  /// Балл 0–100. `null`, если `insufficientData = true`.
  final int? score;

  /// Цветовая зона по порогам (`GREEN`/`YELLOW`/`RED`). `null`, если.
  /// `insufficientData = true`.
  ///
  final PlantHealthDtoZone? zone;

  Map<String, Object?> toJson() => _$PlantHealthDtoToJson(this);
}
