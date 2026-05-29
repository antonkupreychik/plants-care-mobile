// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'weekly_health_bucket.g.dart';

/// Агрегат за одну ISO-неделю месяца.
@JsonSerializable()
class WeeklyHealthBucket {
  const WeeklyHealthBucket({
    required this.week,
    required this.done,
    required this.onTimePct,
  });
  
  factory WeeklyHealthBucket.fromJson(Map<String, Object?> json) => _$WeeklyHealthBucketFromJson(json);
  
  /// ISO-неделя `YYYY-Www` (например, `2026-W19`).
  final String week;

  /// Выполнено задач за неделю.
  final int done;

  /// Доля выполненных вовремя [0, 1].
  final double onTimePct;

  Map<String, Object?> toJson() => _$WeeklyHealthBucketToJson(this);
}
