// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/monthly_report_response.dart';

part 'reports_client.g.dart';

@RestApi()
abstract class ReportsClient {
  factory ReportsClient(Dio dio, {String? baseUrl}) = _ReportsClient;

  /// Месячный отчёт по уходу.
  ///
  /// Возвращает сводку по уходу за указанный месяц для текущего пользователя:.
  /// число выполненных действий, число просроченных (выполненных с опозданием),.
  /// разбивку по типам ухода, текущий стрик и понедельный тренд качества.
  ///
  /// Месяц передаётся параметром `month` в формате `YYYY-MM`. Границы месяца.
  /// вычисляются в таймзоне пользователя (`users.timezone`).
  ///
  /// [month] - Отчётный месяц в формате `YYYY-MM` (например, `2026-05`).
  @GET('/api/v1/reports/monthly')
  Future<MonthlyReportResponse> getMonthlyReport({
    @Query('month') required String month,
    @Extras() Map<String, dynamic>? extras,
  });
}
