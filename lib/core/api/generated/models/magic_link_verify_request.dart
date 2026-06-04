// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'magic_link_verify_request.g.dart';

/// Тело POST /api/v1/auth/email/verify.
@JsonSerializable()
class MagicLinkVerifyRequest {
  const MagicLinkVerifyRequest({
    required this.token,
  });
  
  factory MagicLinkVerifyRequest.fromJson(Map<String, Object?> json) => _$MagicLinkVerifyRequestFromJson(json);
  
  /// Opaque-токен из ссылки в письме.
  final String token;

  Map<String, Object?> toJson() => _$MagicLinkVerifyRequestToJson(this);
}
