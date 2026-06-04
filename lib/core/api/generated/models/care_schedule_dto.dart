// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_schedule_dto_type.dart';
import 'care_schedule_dto_unit.dart';
import 'seasonal_schedule_dto.dart';

part 'care_schedule_dto.g.dart';

/// Расписание ухода растения одного типа.
@JsonSerializable()
class CareScheduleDto {
  const CareScheduleDto({
    required this.type,
    required this.every,
    required this.unit,
    required this.enabled,
    required this.seasonal,
    this.amountMl,
    this.nextDueAt,
  });
  
  factory CareScheduleDto.fromJson(Map<String, Object?> json) => _$CareScheduleDtoFromJson(json);
  
  final CareScheduleDtoType type;

  /// Интервал в днях.
  final int every;

  /// Единица интервала. Сейчас всегда DAY.
  final CareScheduleDtoUnit unit;

  /// Объём полива в миллилитрах. Только для type=WATERING.
  final int? amountMl;
  final bool enabled;

  /// Ближайшее срабатывание (UTC). Заполнено только если enabled=true.
  final DateTime? nextDueAt;
  final SeasonalScheduleDto seasonal;

  Map<String, Object?> toJson() => _$CareScheduleDtoToJson(this);
}
