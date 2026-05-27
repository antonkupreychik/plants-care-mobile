// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'streak_response.g.dart';

/// Ответ `GET /api/v1/stats/streak`.
@JsonSerializable()
class StreakResponse {
  const StreakResponse({
    required this.plantId,
    required this.streak,
  });
  
  factory StreakResponse.fromJson(Map<String, Object?> json) => _$StreakResponseFromJson(json);
  
  final int plantId;

  /// Количество on-time подряд.
  final int streak;

  Map<String, Object?> toJson() => _$StreakResponseToJson(this);
}
