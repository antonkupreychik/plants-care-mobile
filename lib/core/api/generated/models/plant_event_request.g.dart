// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantEventRequest _$PlantEventRequestFromJson(Map<String, dynamic> json) =>
    PlantEventRequest(
      eventType: PlantEventType.fromJson(json['eventType'] as String),
    );

Map<String, dynamic> _$PlantEventRequestToJson(PlantEventRequest instance) =>
    <String, dynamic>{'eventType': instance.eventType};
