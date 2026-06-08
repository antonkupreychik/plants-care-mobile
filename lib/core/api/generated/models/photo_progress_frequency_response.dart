// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'photo_progress_frequency_value.dart';

part 'photo_progress_frequency_response.g.dart';

/// Текущая частота напоминаний о фото после обновления.
@JsonSerializable()
class PhotoProgressFrequencyResponse {
  const PhotoProgressFrequencyResponse({
    required this.frequency,
  });
  
  factory PhotoProgressFrequencyResponse.fromJson(Map<String, Object?> json) => _$PhotoProgressFrequencyResponseFromJson(json);
  
  final PhotoProgressFrequencyValue frequency;

  Map<String, Object?> toJson() => _$PhotoProgressFrequencyResponseToJson(this);
}
