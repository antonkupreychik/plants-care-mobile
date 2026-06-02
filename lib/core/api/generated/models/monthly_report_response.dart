// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'weekly_health_bucket.dart';

part 'monthly_report_response.g.dart';

/// Ответ `GET /api/v1/reports/monthly`.
@JsonSerializable()
class MonthlyReportResponse {
  const MonthlyReportResponse({
    required this.month,
    required this.done,
    required this.overdue,
    required this.byType,
    required this.streak,
    required this.healthTrend,
  });
  
  factory MonthlyReportResponse.fromJson(Map<String, Object?> json) => _$MonthlyReportResponseFromJson(json);
  
  /// Эхо запрошенного месяца (`YYYY-MM`).
  final String month;

  /// Число выполненных действий ухода за месяц.
  final int done;

  /// Число действий, выполненных с опозданием (`onTime = false`).
  final int overdue;

  /// Разбивка `done` по типам ухода. Ключи — имена enum `TaskType`.
  /// (`WATERING`, `MISTING`, `FERTILIZING`, `SOIL_CHECK`); присутствуют.
  /// все четыре, отсутствующие — `0`.
  ///
  final Map<String, int> byType;

  /// Текущий стрик пользователя (дней подряд) на момент запроса.
  final int streak;

  /// Понедельные бакеты качества для ISO-недель, пересекающих месяц.
  final List<WeeklyHealthBucket> healthTrend;

  Map<String, Object?> toJson() => _$MonthlyReportResponseToJson(this);
}
