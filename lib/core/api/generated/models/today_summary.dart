// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'today_summary.g.dart';

/// Сводка по сегодняшним задачам (mobile gap G11, ADR-014).
/// `total == count ==` длине `tasks`. `done + remaining == total`.
///
@JsonSerializable()
class TodaySummary {
  const TodaySummary({
    required this.total,
    required this.done,
    required this.remaining,
    required this.overdue,
  });
  
  factory TodaySummary.fromJson(Map<String, Object?> json) => _$TodaySummaryFromJson(json);
  
  /// Всего задач в выдаче (= `count`).
  final int total;

  /// Задачи, отмеченные сегодня (`doneAt != null`).
  final int done;

  /// Невыполненные задачи (`total - done`).
  final int remaining;

  /// Невыполненные задачи, дедлайн которых уже прошёл (`nextDueAt < now`).
  final int overdue;

  Map<String, Object?> toJson() => _$TodaySummaryToJson(this);
}
