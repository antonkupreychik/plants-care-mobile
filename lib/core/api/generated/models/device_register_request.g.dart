// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRegisterRequest _$DeviceRegisterRequestFromJson(
  Map<String, dynamic> json,
) => DeviceRegisterRequest(
  platform: DeviceRegisterRequestPlatform.fromJson(json['platform'] as String),
  pushToken: json['pushToken'] as String,
);

Map<String, dynamic> _$DeviceRegisterRequestToJson(
  DeviceRegisterRequest instance,
) => <String, dynamic>{
  'platform': instance.platform,
  'pushToken': instance.pushToken,
};
