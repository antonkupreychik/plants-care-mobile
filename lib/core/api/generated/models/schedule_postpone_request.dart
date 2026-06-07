// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'schedule_postpone_request.g.dart';

/// Тело `POST /plants/{id}/schedules/{type}/postpone`.
@JsonSerializable()
class SchedulePostponeRequest {
  const SchedulePostponeRequest({
    required this.days,
  });
  
  factory SchedulePostponeRequest.fromJson(Map<String, Object?> json) => _$SchedulePostponeRequestFromJson(json);
  
  /// На сколько дней перенести ближайшее срабатывание.
  final int days;

  Map<String, Object?> toJson() => _$SchedulePostponeRequestToJson(this);
}
