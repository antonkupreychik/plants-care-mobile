// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'photo_progress_frequency_value.dart';

part 'photo_progress_frequency_request.g.dart';

/// Запрос смены частоты напоминаний о фото.
@JsonSerializable()
class PhotoProgressFrequencyRequest {
  const PhotoProgressFrequencyRequest({
    required this.frequency,
  });
  
  factory PhotoProgressFrequencyRequest.fromJson(Map<String, Object?> json) => _$PhotoProgressFrequencyRequestFromJson(json);
  
  final PhotoProgressFrequencyValue frequency;

  Map<String, Object?> toJson() => _$PhotoProgressFrequencyRequestToJson(this);
}
