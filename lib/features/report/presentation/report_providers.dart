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
/// - [selectedReportMonthProvider] → строка `YYYY-MM` выбранного месяца;
///   по умолчанию — текущий месяц. Переключается через [SelectedReportMonthNotifier].
/// - [monthlyReportProvider]`(month)` → `AsyncValue<MonthlyReport>` (family по
///   строке `YYYY-MM`). Экран дёргает
///   `monthlyReportProvider(ref.watch(selectedReportMonthProvider))`.
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

/// Максимальное количество месяцев назад от текущего, доступных для просмотра.
const _kMaxMonthsBack = 12;

/// Notifier выбранного месяца отчёта (экран 14).
///
/// Начальное состояние — текущий месяц из [currentReportMonthProvider].
/// Переключение строго ограничено:
/// - назад: не более [_kMaxMonthsBack] месяцев от текущего;
/// - вперёд: не дальше текущего месяца (нет будущих месяцев).
///
/// Кодген генерирует **`selectedReportMonthProvider`**.
@riverpod
class SelectedReportMonthNotifier extends _$SelectedReportMonthNotifier {
  @override
  String build() {
    return ref.watch(currentReportMonthProvider);
  }

  /// Перейти на месяц назад, если не превышен лимит [_kMaxMonthsBack].
  void prevMonth() {
    final current = ref.read(currentReportMonthProvider);
    final dt = _parse(state);
    if (_monthsDiff(current, state) >= _kMaxMonthsBack) return;
    final prev = DateTime(dt.year, dt.month - 1);
    state = _format(prev);
  }

  /// Перейти на месяц вперёд, если не дальше текущего месяца.
  void nextMonth() {
    final current = ref.read(currentReportMonthProvider);
    if (state == current) return;
    final dt = _parse(state);
    final next = DateTime(dt.year, dt.month + 1);
    // Ограничение: нельзя уйти в будущее
    if (_format(next).compareTo(current) > 0) return;
    state = _format(next);
  }

  /// Может ли пользователь перейти назад (не превышен лимит)?
  bool get canGoPrev =>
      _monthsDiff(ref.read(currentReportMonthProvider), state) < _kMaxMonthsBack;

  /// Может ли пользователь перейти вперёд (не на текущем месяце)?
  bool get canGoNext => state != ref.read(currentReportMonthProvider);
}

/// Парсит строку `YYYY-MM` в [DateTime] (первый день месяца, UTC).
DateTime _parse(String yyyyMM) {
  final parts = yyyyMM.split('-');
  return DateTime(int.parse(parts[0]), int.parse(parts[1]));
}

/// Форматирует [DateTime] в строку `YYYY-MM`.
String _format(DateTime dt) =>
    '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

/// Количество месяцев от [selected] до [current] (current >= selected).
int _monthsDiff(String current, String selected) {
  final c = _parse(current);
  final s = _parse(selected);
  return (c.year - s.year) * 12 + (c.month - s.month);
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
