// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'guest_login_request.g.dart';

/// Тело POST /api/v1/auth/guest.
@JsonSerializable()
class GuestLoginRequest {
  const GuestLoginRequest({
    required this.deviceId,
  });
  
  factory GuestLoginRequest.fromJson(Map<String, Object?> json) => _$GuestLoginRequestFromJson(json);
  
  /// UUID4 устройства (lowercase). Генерируется клиентом один раз и не меняется.
  final String deviceId;

  Map<String, Object?> toJson() => _$GuestLoginRequestToJson(this);
}
