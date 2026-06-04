import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/reports_repository_provider.dart';
import '../domain/monthly_report.dart';

part 'report_providers.g.dart';

/// State-слой фичи «Месячный отчёт» (экран 14).
///
/// Контракт для ui-builder:
/// - [currentReportMonthProvider] → строка `YYYY-MM` текущего месяца (из
///   `clockProvider`, в локальной TZ пользователя).
/// - [monthlyReportProvider]`(month)` → `AsyncValue<MonthlyReport>` (family по
///   строке `YYYY-MM`). MVP: экран дёргает
///   `monthlyReportProvider(ref.watch(currentReportMonthProvider))`.
///
/// В `AsyncError` лежит типизированный [ApiError] (см. [_unwrap]) — UI маппит
/// его в текст через `AppLocalizations`. Empty-state экрана определяется по
/// `report.isEmpty`; общий процент вовремя — `report.onTimePct` (nullable).

/// Текущий месяц отчёта в формате `YYYY-MM`, посчитанный из `clockProvider`
/// (UTC → локальная TZ пользователя). Не используем `DateTime.now()` напрямую
/// (FLUTTER.md «Время»: тестируемость через инжектируемый Clock).
@riverpod
String currentReportMonth(Ref ref) {
  final now = ref.watch(clockProvider).nowUtc().toLocal();
  final month = now.month.toString().padLeft(2, '0');
  return '${now.year}-$month';
}

/// Месячный отчёт за [month] (`YYYY-MM`, scope user). Family по строке месяца —
/// ui-builder может листать предыдущие месяцы, передавая нужный `YYYY-MM`
/// (валидацию «не в будущее» делает UI/notifier выбора месяца, отдельно).
@riverpod
Future<MonthlyReport> monthlyReport(Ref ref, String month) async {
  final result =
      await ref.watch(reportsRepositoryProvider).getMonthlyReport(month: month);
  return _unwrap(result);
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
