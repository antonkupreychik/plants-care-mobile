// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'weather_snapshot_dto_recommendation.dart';

part 'weather_snapshot_dto.g.dart';

/// Снепшот влажности (mobile gap G4). При `available = false` остальные.
/// поля равны `null` — погода у пользователя не настроена или источник.
/// временно недоступен.
///
@JsonSerializable()
class WeatherSnapshotDto {
  const WeatherSnapshotDto({
    required this.available,
    this.humidityPercent,
    this.recommendation,
    this.fetchedAt,
    this.fromCache,
  });
  
  factory WeatherSnapshotDto.fromJson(Map<String, Object?> json) => _$WeatherSnapshotDtoFromJson(json);
  
  /// `true` — данные о влажности получены; `false` — погода не настроена.
  /// (нет координат / выключена) или внешний источник недоступен.
  ///
  final bool available;

  /// Относительная влажность 0–100%. `null`, если `available = false`.
  final int? humidityPercent;

  /// Рекомендация по поливу: `DEFER_OK` (RH ≥ 80% — можно отложить),.
  /// `DO_NOT_DEFER` (RH ≤ 35% — лучше не откладывать), `NEUTRAL`.
  /// `null`, если `available = false`.
  ///
  final WeatherSnapshotDtoRecommendation? recommendation;

  /// Когда значение было получено из внешнего источника (UTC). `null`, если `available = false`.
  final DateTime? fetchedAt;

  /// `true` — значение взято из серверного кеша (60-мин окно), без.
  /// обращения к внешнему API. `null`, если `available = false`.
  ///
  final bool? fromCache;

  Map<String, Object?> toJson() => _$WeatherSnapshotDtoToJson(this);
}
