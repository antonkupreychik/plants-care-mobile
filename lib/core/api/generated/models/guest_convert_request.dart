// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'guest_convert_request_provider.dart';

part 'guest_convert_request.g.dart';

/// Тело POST /api/v1/auth/guest/convert.
@JsonSerializable()
class GuestConvertRequest {
  const GuestConvertRequest({
    required this.provider,
    this.email,
    this.idToken,
  });
  
  factory GuestConvertRequest.fromJson(Map<String, Object?> json) => _$GuestConvertRequestFromJson(json);
  
  /// Провайдер для конвертации.
  final GuestConvertRequestProvider provider;

  /// Обязателен для `provider=EMAIL`.
  final String? email;

  /// Google или Apple id-token. Обязателен для `provider=GOOGLE`/`APPLE`.
  final String? idToken;

  Map<String, Object?> toJson() => _$GuestConvertRequestToJson(this);
}
