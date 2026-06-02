// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_schedule_update_request_unit.dart';

part 'care_schedule_update_request.g.dart';

@JsonSerializable()
class CareScheduleUpdateRequest {
  const CareScheduleUpdateRequest({
    required this.every,
    required this.unit,
    required this.enabled,
    this.amountMl,
  });
  
  factory CareScheduleUpdateRequest.fromJson(Map<String, Object?> json) => _$CareScheduleUpdateRequestFromJson(json);
  
  final int every;
  final CareScheduleUpdateRequestUnit unit;

  /// Объём полива в миллилитрах. Только для type=WATERING.
  final int? amountMl;
  final bool enabled;

  Map<String, Object?> toJson() => _$CareScheduleUpdateRequestToJson(this);
}
