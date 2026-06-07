// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'device_dto_platform.dart';

part 'device_dto.g.dart';

/// Зарегистрированное устройство.
@JsonSerializable()
class DeviceDto {
  const DeviceDto({
    required this.id,
    required this.platform,
    required this.pushToken,
    required this.createdAt,
    required this.lastSeenAt,
  });
  
  factory DeviceDto.fromJson(Map<String, Object?> json) => _$DeviceDtoFromJson(json);
  
  final int id;
  final DeviceDtoPlatform platform;
  final String pushToken;

  /// Момент регистрации в UTC.
  final DateTime createdAt;

  /// Последнее обновление токена в UTC.
  final DateTime lastSeenAt;

  Map<String, Object?> toJson() => _$DeviceDtoToJson(this);
}
