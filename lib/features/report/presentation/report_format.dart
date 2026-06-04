import 'package:intl/intl.dart';

/// Локализация подписей месяца/недели для экрана отчёта (presentation-only).
///
/// Парсит уже посчитанные backend строки (`YYYY-MM`, ISO `YYYY-Www`) и
/// форматирует их для UI. Никакой бизнес-логики/расчётов — только отображение.
class ReportFormat {
  const ReportFormat._();

  /// `YYYY-MM` → «май 2026» (название месяца в локали `localeName`).
  /// Невалидная строка → возвращается как есть (UI не падает).
  static String monthLabel(String month, String localeName) {
    final parts = month.split('-');
    if (parts.length != 2) return month;
    final year = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (year == null || m == null || m < 1 || m > 12) return month;
    final name = DateFormat.MMMM(localeName).format(DateTime(year, m));
    return '$name $year';
  }

  /// ISO `YYYY-Www` → номер недели как строка (`19`). Невалидная строка →
  /// исходная строка (UI не падает).
  static String weekNumber(String isoWeek) {
    final idx = isoWeek.indexOf('-W');
    if (idx == -1) return isoWeek;
    return isoWeek.substring(idx + 2);
  }
}
