// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_health_response_zone.dart';

part 'plant_health_response.g.dart';

/// Индекс здоровья растения, посчитанный backend.
@JsonSerializable()
class PlantHealthResponse {
  const PlantHealthResponse({
    required this.insufficientData,
    required this.score,
    required this.zone,
  });
  
  factory PlantHealthResponse.fromJson(Map<String, Object?> json) => _$PlantHealthResponseFromJson(json);
  
  /// `true`, если данных для достоверной оценки недостаточно. В этом случае.
  /// `score`/`zone` не следует подавать как точную метрику.
  ///
  final bool insufficientData;

  /// Индекс здоровья в диапазоне [0, 100].
  final int score;

  /// Зона здоровья, производная от `score`.
  final PlantHealthResponseZone zone;

  Map<String, Object?> toJson() => _$PlantHealthResponseToJson(this);
}
