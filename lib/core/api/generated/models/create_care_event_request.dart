// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_event_type.dart';

part 'create_care_event_request.g.dart';

/// Тело POST /api/v1/care-events.
@JsonSerializable()
class CreateCareEventRequest {
  const CreateCareEventRequest({
    required this.plantId,
    required this.type,
    required this.performedAt,
    this.note,
    this.clientId,
  });
  
  factory CreateCareEventRequest.fromJson(Map<String, Object?> json) => _$CreateCareEventRequestFromJson(json);
  
  final int plantId;
  final CareEventType type;

  /// Момент выполнения ухода (UTC).
  final DateTime performedAt;

  /// Необязательная заметка (например, «добавил удобрение X»).
  final String? note;

  /// UUID от клиента для идемпотентности при retry. Если null — идемпотентность отключена.
  final String? clientId;

  Map<String, Object?> toJson() => _$CreateCareEventRequestToJson(this);
}
