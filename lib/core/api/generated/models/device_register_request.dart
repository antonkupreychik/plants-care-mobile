// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'device_register_request_platform.dart';

part 'device_register_request.g.dart';

/// Запрос на регистрацию устройства.
@JsonSerializable()
class DeviceRegisterRequest {
  const DeviceRegisterRequest({
    required this.platform,
    required this.pushToken,
  });
  
  factory DeviceRegisterRequest.fromJson(Map<String, Object?> json) => _$DeviceRegisterRequestFromJson(json);
  
  /// Мобильная платформа.
  final DeviceRegisterRequestPlatform platform;

  /// Push-токен устройства (FCM / APNs).
  final String pushToken;

  Map<String, Object?> toJson() => _$DeviceRegisterRequestToJson(this);
}
