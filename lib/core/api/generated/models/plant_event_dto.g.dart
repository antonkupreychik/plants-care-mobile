// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantEventDto _$PlantEventDtoFromJson(Map<String, dynamic> json) =>
    PlantEventDto(
      id: (json['id'] as num).toInt(),
      eventType: PlantEventType.fromJson(json['eventType'] as String),
      eventDate: DateTime.parse(json['eventDate'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$PlantEventDtoToJson(PlantEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventType': instance.eventType,
      'eventDate': instance.eventDate.toIso8601String(),
      'comment': instance.comment,
    };
