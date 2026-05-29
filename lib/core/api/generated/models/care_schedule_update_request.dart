// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'care_schedule_update_request.g.dart';

/// Тело `PUT /api/v1/plants/{id}/schedules/{type}`.
@JsonSerializable()
class CareScheduleUpdateRequest {
  const CareScheduleUpdateRequest({
    required this.every,
    required this.unit,
    required this.enabled,
    this.amountMl,
  });
  
  factory CareScheduleUpdateRequest.fromJson(Map<String, Object?> json) => _$CareScheduleUpdateRequestFromJson(json);
  
  /// Интервал повторения в единицах [unit]. Не меньше 1.
  final int every;

  /// Единица интервала (например, `DAY`).
  final String unit;

  /// Объём воды в миллилитрах (для полива). `null` — не задан.
  final int? amountMl;

  /// Активно ли расписание.
  final bool enabled;

  Map<String, Object?> toJson() => _$CareScheduleUpdateRequestToJson(this);
}
