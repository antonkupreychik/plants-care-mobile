// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDto _$DeviceDtoFromJson(Map<String, dynamic> json) => DeviceDto(
  id: (json['id'] as num).toInt(),
  platform: DeviceDtoPlatform.fromJson(json['platform'] as String),
  pushToken: json['pushToken'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastSeenAt: DateTime.parse(json['lastSeenAt'] as String),
);

Map<String, dynamic> _$DeviceDtoToJson(DeviceDto instance) => <String, dynamic>{
  'id': instance.id,
  'platform': instance.platform,
  'pushToken': instance.pushToken,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastSeenAt': instance.lastSeenAt.toIso8601String(),
};
