// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'day_progress.g.dart';

/// Прогресс за один день — запланировано/выполнено в TZ пользователя.
@JsonSerializable()
class DayProgress {
  const DayProgress({
    required this.planned,
    required this.done,
  });
  
  factory DayProgress.fromJson(Map<String, Object?> json) => _$DayProgressFromJson(json);
  
  /// Количество запланированных occurrence'ов в этот локальный день.
  final int planned;

  /// Количество выполненных (не отменённых) записей в этот локальный день.
  final int done;

  Map<String, Object?> toJson() => _$DayProgressToJson(this);
}
