// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'weekly_health_bucket.g.dart';

/// Качество ухода за одну ISO-неделю.
@JsonSerializable()
class WeeklyHealthBucket {
  const WeeklyHealthBucket({
    required this.week,
    required this.done,
    required this.onTimePct,
  });
  
  factory WeeklyHealthBucket.fromJson(Map<String, Object?> json) => _$WeeklyHealthBucketFromJson(json);
  
  /// ISO-8601 неделя в формате `YYYY-Www` (например, `2026-W18`).
  final String week;

  /// Число выполненных действий за неделю.
  final int done;

  /// Доля on-time действий (`onTime/done`), округлённая до 2 знаков; `0.0` если `done == 0`.
  final double onTimePct;

  Map<String, Object?> toJson() => _$WeeklyHealthBucketToJson(this);
}
