// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'task_dto.dart';

part 'today_response.g.dart';

/// Ответ `GET /api/v1/today`.
@JsonSerializable()
class TodayResponse {
  const TodayResponse({
    required this.tasks,
    required this.count,
  });
  
  factory TodayResponse.fromJson(Map<String, Object?> json) => _$TodayResponseFromJson(json);
  
  final List<TaskDto> tasks;

  /// Длина `tasks` (дублируется для удобства клиента).
  final int count;

  Map<String, Object?> toJson() => _$TodayResponseToJson(this);
}
