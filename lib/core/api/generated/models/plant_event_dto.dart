// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'plant_event_type.dart';

part 'plant_event_dto.g.dart';

/// Запись журнала событий растения.
@JsonSerializable()
class PlantEventDto {
  const PlantEventDto({
    required this.id,
    required this.eventType,
    required this.eventDate,
    this.comment,
  });
  
  factory PlantEventDto.fromJson(Map<String, Object?> json) => _$PlantEventDtoFromJson(json);
  
  final int id;
  final PlantEventType eventType;

  /// Момент события в UTC.
  final DateTime eventDate;

  /// Необязательный комментарий. В v1 всегда null.
  final String? comment;

  Map<String, Object?> toJson() => _$PlantEventDtoToJson(this);
}
