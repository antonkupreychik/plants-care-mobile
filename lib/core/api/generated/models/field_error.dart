// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'field_error.g.dart';

@JsonSerializable()
class FieldError {
  const FieldError({
    required this.field,
    required this.message,
  });
  
  factory FieldError.fromJson(Map<String, Object?> json) => _$FieldErrorFromJson(json);
  
  final String field;
  final String message;

  Map<String, Object?> toJson() => _$FieldErrorToJson(this);
}
