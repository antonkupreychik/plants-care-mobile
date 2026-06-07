// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_event_type.dart';

part 'plant_event_request.g.dart';

/// Тело POST /api/v1/plants/{id}/events.
@JsonSerializable()
class PlantEventRequest {
  const PlantEventRequest({
    required this.eventType,
  });
  
  factory PlantEventRequest.fromJson(Map<String, Object?> json) => _$PlantEventRequestFromJson(json);
  
  final PlantEventType eventType;

  Map<String, Object?> toJson() => _$PlantEventRequestToJson(this);
}
