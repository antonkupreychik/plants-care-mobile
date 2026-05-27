// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_event_type.dart';

part 'care_event_response.g.dart';

/// Запись события ухода после регистрации или из истории.
@JsonSerializable()
class CareEventResponse {
  const CareEventResponse({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.type,
    required this.performedAt,
    required this.onTime,
    this.note,
    this.clientId,
  });
  
  factory CareEventResponse.fromJson(Map<String, Object?> json) => _$CareEventResponseFromJson(json);
  
  final int id;
  final int plantId;
  final String plantName;
  final CareEventType type;

  /// Момент выполнения в UTC.
  final DateTime performedAt;
  final String? note;
  final String? clientId;

  /// Признак выполнения «в срок» — выполнено до дедлайна расписания.
  /// Используется для расчёта стрика.
  ///
  final bool onTime;

  Map<String, Object?> toJson() => _$CareEventResponseToJson(this);
}
