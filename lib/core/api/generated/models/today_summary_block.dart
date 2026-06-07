// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'block.dart';
import 'today_summary_block_type.dart';

part 'today_summary_block.g.dart';

/// Сводка по сегодняшним задачам ухода. Совпадает по смыслу с `TodaySummary`.
/// (`done + remaining == total`).
///
@JsonSerializable()
class TodaySummaryBlock {
  const TodaySummaryBlock({
    required this.type,
    required this.total,
    required this.done,
    required this.remaining,
    required this.overdue,
  });
  
  factory TodaySummaryBlock.fromJson(Map<String, Object?> json) => _$TodaySummaryBlockFromJson(json);
  
  /// Дискриминатор блока.
  final TodaySummaryBlockType type;

  /// Всего задач на сегодня.
  final int total;

  /// Выполненные задачи.
  final int done;

  /// Невыполненные задачи (`total - done`).
  final int remaining;

  /// Невыполненные просроченные задачи.
  final int overdue;

  Map<String, Object?> toJson() => _$TodaySummaryBlockToJson(this);
}
