// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'weekly_health_bucket.dart';

part 'monthly_report_response.g.dart';

/// Ответ `GET /api/v1/reports/monthly`. Агрегаты посчитаны backend.
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
  
  /// Месяц отчёта `YYYY-MM`.
  final String month;

  /// Всего выполненных задач ухода за месяц.
  final int done;

  /// Всего просроченных (невыполненных в срок) задач за месяц.
  final int overdue;

  /// Разбивка выполненных задач по типу ухода. Ключ — строковый код типа.
  /// (`WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`), значение —.
  /// количество. Неизвестные ключи клиент игнорирует.
  ///
  final Map<String, int> byType;

  /// Текущий стрик (выполнений вовремя подряд).
  final int streak;

  /// Понедельный тренд за месяц (выполнено + доля вовремя).
  final List<WeeklyHealthBucket> healthTrend;

  Map<String, Object?> toJson() => _$MonthlyReportResponseToJson(this);
}
