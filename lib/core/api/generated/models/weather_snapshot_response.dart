// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'weather_snapshot_response_recommendation.dart';

part 'weather_snapshot_response.g.dart';

/// Снапшот погоды для рекомендаций по поливу, посчитанный backend.
/// При `available=false` все остальные поля — `null`.
///
@JsonSerializable()
class WeatherSnapshotResponse {
  const WeatherSnapshotResponse({
    required this.available,
    this.humidityPercent,
    this.recommendation,
    this.fetchedAt,
    this.fromCache,
  });
  
  factory WeatherSnapshotResponse.fromJson(Map<String, Object?> json) => _$WeatherSnapshotResponseFromJson(json);
  
  /// `true`, если данные погоды доступны (источник настроен и ответил).
  /// При `false` остальные поля приходят `null`, UI не рисует строку погоды.
  ///
  final bool available;

  /// Относительная влажность воздуха [0, 100]. `null`, если `available=false`.
  ///
  final int? humidityPercent;

  /// Рекомендация backend по поливу: можно отложить (`DEFER_OK`),.
  /// откладывать не стоит (`DO_NOT_DEFER`), нейтрально (`NEUTRAL`).
  /// `null`, если `available=false`. Клиент рекомендацию не пересчитывает.
  ///
  final WeatherSnapshotResponseRecommendation? recommendation;

  /// Момент получения данных от источника (UTC, ISO-8601). `null`, если.
  /// `available=false`.
  ///
  final DateTime? fetchedAt;

  /// `true`, если снапшот отдан из серверного кеша (~60 мин), а не запрошен.
  /// у источника заново. `null`, если `available=false`.
  ///
  final bool? fromCache;

  Map<String, Object?> toJson() => _$WeatherSnapshotResponseToJson(this);
}
