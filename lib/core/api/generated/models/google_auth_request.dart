// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'google_auth_request.g.dart';

/// Тело POST /api/v1/auth/google.
@JsonSerializable()
class GoogleAuthRequest {
  const GoogleAuthRequest({
    required this.idToken,
  });
  
  factory GoogleAuthRequest.fromJson(Map<String, Object?> json) => _$GoogleAuthRequestFromJson(json);
  
  /// Google OIDC id_token.
  final String idToken;

  Map<String, Object?> toJson() => _$GoogleAuthRequestToJson(this);
}
