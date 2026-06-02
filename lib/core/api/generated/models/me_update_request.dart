// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'me_update_request.g.dart';

/// Частичное обновление настроек. Все поля опциональны — отсутствующие.
/// остаются без изменений.
///
@JsonSerializable()
class MeUpdateRequest {
  const MeUpdateRequest({
    this.quietHoursStart,
    this.quietHoursEnd,
    this.timezone,
    this.locale,
    this.seasonalEnabled,
    this.seasonalMode,
    this.weatherEnabled,
  });
  
  factory MeUpdateRequest.fromJson(Map<String, Object?> json) => _$MeUpdateRequestFromJson(json);
  
  /// Начало тихих часов, локальное время `HH:mm`.
  final String? quietHoursStart;

  /// Конец тихих часов, локальное время `HH:mm`.
  final String? quietHoursEnd;

  /// IANA-идентификатор таймзоны. Невалидный → `400`.
  final String? timezone;

  /// Язык интерфейса/уведомлений. Допустимые значения — `ru` или `en`.
  final String? locale;

  /// Учитывать сезоны при расчёте следующего полива.
  final bool? seasonalEnabled;

  /// Режим сезонности. Допустимые значения — `MULTIPLIER` или `FIXED`.
  final String? seasonalMode;

  /// Учитывать погоду в рекомендациях.
  final bool? weatherEnabled;

  Map<String, Object?> toJson() => _$MeUpdateRequestToJson(this);
}
