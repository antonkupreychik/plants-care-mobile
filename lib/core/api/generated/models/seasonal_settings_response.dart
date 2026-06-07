// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'season_settings.dart';
import 'seasonal_settings_response_mode.dart';

part 'seasonal_settings_response.g.dart';

/// Per-season настройки сезонности пользователя (`GET /api/v1/me/seasonal`).
/// `enabled`/`mode` отдаются для контекста; меняются через `PATCH /api/v1/me`.
///
@JsonSerializable()
class SeasonalSettingsResponse {
  const SeasonalSettingsResponse({
    required this.enabled,
    required this.mode,
    required this.seasons,
  });
  
  factory SeasonalSettingsResponse.fromJson(Map<String, Object?> json) => _$SeasonalSettingsResponseFromJson(json);
  
  /// Глобальный флаг учёта сезонов (зеркало `seasonalEnabled`).
  final bool enabled;

  /// Активный режим сезонности (зеркало `seasonalMode`).
  final SeasonalSettingsResponseMode mode;

  /// Настройки по каждому сезону (`SUMMER`, `WINTER`).
  final List<SeasonSettings> seasons;

  Map<String, Object?> toJson() => _$SeasonalSettingsResponseToJson(this);
}
