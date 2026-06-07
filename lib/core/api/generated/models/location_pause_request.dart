// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'location_pause_request.g.dart';

/// Запрос на паузу локации.
@JsonSerializable()
class LocationPauseRequest {
  const LocationPauseRequest({
    required this.days,
  });
  
  factory LocationPauseRequest.fromJson(Map<String, Object?> json) => _$LocationPauseRequestFromJson(json);
  
  /// Количество дней паузы (1–180).
  final int days;

  Map<String, Object?> toJson() => _$LocationPauseRequestToJson(this);
}
