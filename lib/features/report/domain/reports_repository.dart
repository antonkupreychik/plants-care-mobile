import '../../../core/error/result.dart';
import 'monthly_report.dart';

/// Контракт data-слоя для фичи «Месячный отчёт» (экран 14).
///
/// Одно чтение — агрегаты за месяц (`GET /reports/monthly`, scope user —
/// идентификация по `X-User-Id`). Значения посчитаны backend, клиент их не
/// пересчитывает. Возвращает `Future<Result<T>>` и НЕ бросает наружу
/// (MADR-011).
abstract interface class ReportsRepository {
  /// Месячный отчёт за [month] (`YYYY-MM`). Если [month] равен `null` —
  /// backend берёт текущий месяц пользователя.
  Future<Result<MonthlyReport>> getMonthlyReport({String? month});
}
