// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'refresh_request.g.dart';

/// Тело POST /api/v1/auth/refresh.
@JsonSerializable()
class RefreshRequest {
  const RefreshRequest({
    required this.refreshToken,
  });
  
  factory RefreshRequest.fromJson(Map<String, Object?> json) => _$RefreshRequestFromJson(json);
  
  /// Refresh-токен, полученный при предыдущем входе/ротации.
  final String refreshToken;

  Map<String, Object?> toJson() => _$RefreshRequestToJson(this);
}
