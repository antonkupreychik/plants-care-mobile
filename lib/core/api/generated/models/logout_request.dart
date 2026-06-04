// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'logout_request.g.dart';

/// Тело POST /api/v1/auth/logout.
@JsonSerializable()
class LogoutRequest {
  const LogoutRequest({
    required this.refreshToken,
  });
  
  factory LogoutRequest.fromJson(Map<String, Object?> json) => _$LogoutRequestFromJson(json);
  
  /// Refresh-токен текущей сессии, который нужно отозвать.
  final String refreshToken;

  Map<String, Object?> toJson() => _$LogoutRequestToJson(this);
}
