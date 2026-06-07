// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'schedule_input_type.dart';
import 'schedule_input_unit.dart';

part 'schedule_input.g.dart';

/// Расписание ухода при создании растения.
@JsonSerializable()
class ScheduleInput {
  const ScheduleInput({
    required this.type,
    required this.every,
    required this.unit,
    this.amountMl,
  });
  
  factory ScheduleInput.fromJson(Map<String, Object?> json) => _$ScheduleInputFromJson(json);
  
  final ScheduleInputType type;
  final int every;
  final ScheduleInputUnit unit;

  /// Объём полива в мл. Только для WATERING.
  final int? amountMl;

  Map<String, Object?> toJson() => _$ScheduleInputToJson(this);
}
