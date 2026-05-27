// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'api_error.dart';

part 'api_error_response.g.dart';

/// Стандартная обёртка над ошибкой REST API.
@JsonSerializable()
class ApiErrorResponse {
  const ApiErrorResponse({
    required this.error,
  });
  
  factory ApiErrorResponse.fromJson(Map<String, Object?> json) => _$ApiErrorResponseFromJson(json);
  
  final ApiError error;

  Map<String, Object?> toJson() => _$ApiErrorResponseToJson(this);
}
