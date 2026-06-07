// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse(
  plants: (json['plants'] as List<dynamic>)
      .map((e) => SyncPlantDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  locations: (json['locations'] as List<dynamic>)
      .map((e) => SyncLocationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  careEvents: (json['careEvents'] as List<dynamic>)
      .map((e) => SyncCareEventDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  deletions: (json['deletions'] as List<dynamic>)
      .map((e) => SyncDeletionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  serverTime: DateTime.parse(json['serverTime'] as String),
);

Map<String, dynamic> _$SyncResponseToJson(SyncResponse instance) =>
    <String, dynamic>{
      'plants': instance.plants,
      'locations': instance.locations,
      'careEvents': instance.careEvents,
      'deletions': instance.deletions,
      'serverTime': instance.serverTime.toIso8601String(),
    };
