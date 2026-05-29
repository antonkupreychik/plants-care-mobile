// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'care_schedule_dto.g.dart';

/// Расписание ухода одного типа для растения. Интервалы и `nextDueAt`.
/// посчитаны backend; клиент их не пересчитывает.
///
@JsonSerializable()
class CareScheduleDto {
  const CareScheduleDto({
    required this.type,
    required this.every,
    required this.unit,
    required this.enabled,
    this.amountMl,
    this.nextDueAt,
  });
  
  factory CareScheduleDto.fromJson(Map<String, Object?> json) => _$CareScheduleDtoFromJson(json);
  
  /// Тип ухода (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`).
  /// Строка нормализуется маппером в domain-enum.
  ///
  final String type;

  /// Интервал повторения в единицах [unit].
  final int every;

  /// Единица интервала (например, `DAY`). Строка, не enum — маппер.
  /// нормализует в domain.
  ///
  final String unit;

  /// Объём воды в миллилитрах (для полива). `null` — не задан / не.
  /// применим к типу.
  ///
  final int? amountMl;

  /// Активно ли расписание (генерирует ли задачи).
  final bool enabled;

  /// Момент следующей задачи (UTC), посчитан backend. `null` — расписание.
  /// неактивно / срок не определён.
  ///
  final DateTime? nextDueAt;

  Map<String, Object?> toJson() => _$CareScheduleDtoToJson(this);
}
