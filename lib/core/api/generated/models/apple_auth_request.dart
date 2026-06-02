// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'apple_auth_request.g.dart';

/// Тело POST /api/v1/auth/apple.
@JsonSerializable()
class AppleAuthRequest {
  const AppleAuthRequest({
    required this.identityToken,
  });
  
  factory AppleAuthRequest.fromJson(Map<String, Object?> json) => _$AppleAuthRequestFromJson(json);
  
  /// JWT identity token, выданный Sign in with Apple.
  final String identityToken;

  Map<String, Object?> toJson() => _$AppleAuthRequestToJson(this);
}
