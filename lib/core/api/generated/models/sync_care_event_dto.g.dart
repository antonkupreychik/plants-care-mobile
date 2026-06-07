// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_care_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncCareEventDto _$SyncCareEventDtoFromJson(Map<String, dynamic> json) =>
    SyncCareEventDto(
      id: (json['id'] as num).toInt(),
      plantId: (json['plantId'] as num).toInt(),
      type: CareEventType.fromJson(json['type'] as String),
      performedAt: DateTime.parse(json['performedAt'] as String),
      onTime: json['onTime'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      note: json['note'] as String?,
      clientId: json['clientId'] as String?,
    );

Map<String, dynamic> _$SyncCareEventDtoToJson(SyncCareEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'type': instance.type,
      'performedAt': instance.performedAt.toIso8601String(),
      'onTime': instance.onTime,
      'note': instance.note,
      'clientId': instance.clientId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
