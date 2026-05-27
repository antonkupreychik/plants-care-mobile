// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareEventResponse _$CareEventResponseFromJson(Map<String, dynamic> json) =>
    CareEventResponse(
      id: (json['id'] as num).toInt(),
      plantId: (json['plantId'] as num).toInt(),
      plantName: json['plantName'] as String,
      type: CareEventType.fromJson(json['type'] as String),
      performedAt: DateTime.parse(json['performedAt'] as String),
      onTime: json['onTime'] as bool,
      note: json['note'] as String?,
      clientId: json['clientId'] as String?,
    );

Map<String, dynamic> _$CareEventResponseToJson(CareEventResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'plantName': instance.plantName,
      'type': instance.type,
      'performedAt': instance.performedAt.toIso8601String(),
      'note': instance.note,
      'clientId': instance.clientId,
      'onTime': instance.onTime,
    };
