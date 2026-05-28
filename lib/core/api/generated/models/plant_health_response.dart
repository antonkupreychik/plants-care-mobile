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
    this.score,
    this.zone,
  });
  
  factory PlantHealthResponse.fromJson(Map<String, Object?> json) => _$PlantHealthResponseFromJson(json);
  
  /// `true`, если данных для достоверной оценки недостаточно (< 3 записей.
  /// ухода). В этом случае `score`/`zone` приходят `null`, UI рисует.
  /// нейтральное состояние.
  ///
  final bool insufficientData;

  /// Индекс здоровья [0, 100]. `null`, если `insufficientData`.
  ///
  final int? score;

  /// Зона здоровья, производная от `score`. `null`, если `insufficientData`.
  ///
  final PlantHealthResponseZone? zone;

  Map<String, Object?> toJson() => _$PlantHealthResponseToJson(this);
}
