// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'season.dart';

part 'season_settings.g.dart';

/// Настройки одного сезона (множитель и фиксированный интервал).
@JsonSerializable()
class SeasonSettings {
  const SeasonSettings({
    required this.season,
    required this.multiplier,
    this.intervalDays,
  });
  
  factory SeasonSettings.fromJson(Map<String, Object?> json) => _$SeasonSettingsFromJson(json);
  
  final Season season;

  /// Коэффициент к базовому интервалу растения. Применяется в режиме.
  /// `MULTIPLIER`. Например, базовый 10 дней × 0.8 = полив каждые 8 дней.
  ///
  final double multiplier;

  /// Фиксированный интервал в днях для этого сезона. Применяется в режиме.
  /// `FIXED`. `null` — интервал не задан, используется базовый интервал.
  /// растения.
  ///
  final int? intervalDays;

  Map<String, Object?> toJson() => _$SeasonSettingsToJson(this);
}
