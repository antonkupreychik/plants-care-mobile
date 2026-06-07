// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'care_event_type.dart';

part 'sync_care_event_dto.g.dart';

/// Снапшот события ухода для офлайн-синка.
@JsonSerializable()
class SyncCareEventDto {
  const SyncCareEventDto({
    required this.id,
    required this.plantId,
    required this.type,
    required this.performedAt,
    required this.onTime,
    required this.updatedAt,
    this.note,
    this.clientId,
  });
  
  factory SyncCareEventDto.fromJson(Map<String, Object?> json) => _$SyncCareEventDtoFromJson(json);
  
  final int id;
  final int plantId;
  final CareEventType type;

  /// Момент выполнения ухода (UTC).
  final DateTime performedAt;
  final bool onTime;
  final String? note;

  /// UUID от клиента при создании. Null для событий из бота.
  final String? clientId;

  /// Момент последнего изменения (UTC).
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$SyncCareEventDtoToJson(this);
}
