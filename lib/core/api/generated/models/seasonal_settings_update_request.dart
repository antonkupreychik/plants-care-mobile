// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'season.dart';

part 'seasonal_settings_update_request.g.dart';

/// Задать множитель и/или фиксированный интервал одного сезона. `season`.
/// обязателен; `multiplier`/`intervalDays` опциональны (отсутствующие не меняются).
///
@JsonSerializable()
class SeasonalSettingsUpdateRequest {
  const SeasonalSettingsUpdateRequest({
    required this.season,
    this.multiplier,
    this.intervalDays,
  });
  
  factory SeasonalSettingsUpdateRequest.fromJson(Map<String, Object?> json) => _$SeasonalSettingsUpdateRequestFromJson(json);
  
  final Season season;

  /// Коэффициент к базовому интервалу (`0.50..1.50`).
  final double? multiplier;

  /// Фиксированный интервал в днях (`1..60`). Для сброса в дефолт используйте.
  /// `DELETE /api/v1/me/seasonal/{season}`.
  ///
  final int? intervalDays;

  Map<String, Object?> toJson() => _$SeasonalSettingsUpdateRequestToJson(this);
}
