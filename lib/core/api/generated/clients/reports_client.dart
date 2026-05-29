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
  /// Возвращает агрегированный отчёт за календарный месяц: количество.
  /// выполненных и просроченных задач, разбивку выполненных по типам ухода,.
  /// текущий стрик и понедельный тренд (выполнено + доля вовремя).
  ///
  /// Разбивки по растениям и «звёзд месяца» backend не отдаёт.
  ///
  /// Идентификация пользователя — по заголовку `X-User-Id`.
  ///
  /// [xUserId] - Внутренний идентификатор пользователя (поле `users.id` в БД). Временный.
  /// способ идентификации до появления настоящей авторизации.
  ///
  ///
  /// [month] - Месяц отчёта в формате `YYYY-MM` (например, `2026-05`). Строка, НЕ.
  /// дата. Если не передан — backend берёт текущий месяц пользователя.
  @GET('/api/v1/reports/monthly')
  Future<MonthlyReportResponse> getMonthlyReport({
    @Header('X-User-Id') required int xUserId,
    @Query('month') String? month,
    @Extras() Map<String, dynamic>? extras,
  });
}
