// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_care_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCareEventRequest _$CreateCareEventRequestFromJson(
  Map<String, dynamic> json,
) => CreateCareEventRequest(
  plantId: (json['plantId'] as num).toInt(),
  type: CareEventType.fromJson(json['type'] as String),
  performedAt: DateTime.parse(json['performedAt'] as String),
  note: json['note'] as String?,
  clientId: json['clientId'] as String?,
);

Map<String, dynamic> _$CreateCareEventRequestToJson(
  CreateCareEventRequest instance,
) => <String, dynamic>{
  'plantId': instance.plantId,
  'type': instance.type,
  'performedAt': instance.performedAt.toIso8601String(),
  'note': instance.note,
  'clientId': instance.clientId,
};
