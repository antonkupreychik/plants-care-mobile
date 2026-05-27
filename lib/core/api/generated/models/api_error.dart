// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'field_error.dart';

part 'api_error.g.dart';

/// Тело ошибки.
@JsonSerializable()
class ApiError {
  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });
  
  factory ApiError.fromJson(Map<String, Object?> json) => _$ApiErrorFromJson(json);
  
  /// Стабильный машиночитаемый код. Значения:.
  /// `VALIDATION_ERROR`, `BAD_REQUEST`, `NOT_FOUND`, `ACCESS_DENIED`,.
  /// `CONFLICT`, `INTERNAL_ERROR`, `LOCATION_NOT_EMPTY`.
  ///
  final String code;
  final String message;

  /// Список ошибок по полям. Заполняется только для `VALIDATION_ERROR`.
  final List<FieldError>? details;

  Map<String, Object?> toJson() => _$ApiErrorToJson(this);
}
