// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'email_request.g.dart';

/// Тело POST /api/v1/auth/email/request.
@JsonSerializable()
class EmailRequest {
  const EmailRequest({
    required this.email,
  });
  
  factory EmailRequest.fromJson(Map<String, Object?> json) => _$EmailRequestFromJson(json);
  
  /// Email, на который отправить magic link.
  final String email;

  Map<String, Object?> toJson() => _$EmailRequestToJson(this);
}
