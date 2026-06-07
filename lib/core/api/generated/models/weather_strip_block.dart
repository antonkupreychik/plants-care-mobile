// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'block.dart';
import 'weather_strip_block_recommendation.dart';
import 'weather_strip_block_type.dart';

part 'weather_strip_block.g.dart';

/// Блок строки погоды (влажность + рекомендация по поливу). Совпадает по.
/// смыслу с `WeatherSnapshotDto`. При `available = false` остальные поля.
/// равны `null`.
///
@JsonSerializable()
class WeatherStripBlock {
  const WeatherStripBlock({
    required this.type,
    required this.available,
    this.humidityPercent,
    this.recommendation,
    this.fetchedAt,
    this.fromCache,
  });
  
  factory WeatherStripBlock.fromJson(Map<String, Object?> json) => _$WeatherStripBlockFromJson(json);
  
  /// Дискриминатор блока.
  final WeatherStripBlockType type;

  /// `true` — данные о влажности получены; `false` — недоступно.
  final bool available;

  /// Относительная влажность 0–100%. `null`, если `available = false`.
  final int? humidityPercent;

  /// Рекомендация по поливу: `DEFER_OK` (можно отложить),.
  /// `DO_NOT_DEFER` (лучше не откладывать), `NEUTRAL`.
  /// `null`, если `available = false`.
  ///
  final WeatherStripBlockRecommendation? recommendation;

  /// Когда значение получено из внешнего источника (UTC). `null`, если `available = false`.
  final DateTime? fetchedAt;

  /// `true` — значение из серверного кеша. `null`, если `available = false`.
  final bool? fromCache;

  Map<String, Object?> toJson() => _$WeatherStripBlockToJson(this);
}
