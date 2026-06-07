// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'plant_history_summary_dto.g.dart';

/// Агрегированная статистика по всей истории ухода за растением.
@JsonSerializable()
class PlantHistorySummaryDto {
  const PlantHistorySummaryDto({
    required this.total,
    required this.onTimeCount,
    required this.onTimePercent,
    required this.byType,
  });
  
  factory PlantHistorySummaryDto.fromJson(Map<String, Object?> json) => _$PlantHistorySummaryDtoFromJson(json);
  
  /// Всего активных (не отменённых) записей истории.
  final int total;

  /// Из них выполненных вовремя (`was_on_time = true`).
  final int onTimeCount;

  /// Процент вовремя выполненных. 0 если `total = 0`.
  final int onTimePercent;

  /// Разбивка по типам ухода. Только типы с `count > 0`, `SOIL_CHECK` исключён.
  /// Ключи — значения `CareEventType` (`WATER`, `SPRAY`, `FERTILIZE`).
  ///
  final Map<String, int> byType;

  Map<String, Object?> toJson() => _$PlantHistorySummaryDtoToJson(this);
}
