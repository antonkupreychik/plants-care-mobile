// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'seasonal_schedule_dto.g.dart';

/// Сезонные параметры расписания ухода (issue #188 backend / G20 mobile #48).
/// Показывает, включена ли авто-подстройка и каким будет эффективный.
/// интервал в каждый из двух сезонов (лето / зима).
///
@JsonSerializable()
class SeasonalScheduleDto {
  const SeasonalScheduleDto({
    required this.active,
    required this.summerIntervalDays,
    required this.winterIntervalDays,
  });
  
  factory SeasonalScheduleDto.fromJson(Map<String, Object?> json) => _$SeasonalScheduleDtoFromJson(json);
  
  /// Активна ли авто-подстройка по сезонам для этого растения.
  final bool active;

  /// Эффективный интервал ухода в летний период (дней).
  final int summerIntervalDays;

  /// Эффективный интервал ухода в зимний период (дней).
  final int winterIntervalDays;

  Map<String, Object?> toJson() => _$SeasonalScheduleDtoToJson(this);
}
