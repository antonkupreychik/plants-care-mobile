import '../../../../core/api/generated/models/monthly_report_response.dart';
import '../../../../core/api/generated/models/weekly_health_bucket.dart'
    as dto;
import '../../../../core/care/care_task_type.dart';
import '../../domain/monthly_report.dart';
import '../../domain/weekly_health_bucket.dart';

/// Маппинг [MonthlyReportResponse] (`/reports/monthly`) → domain
/// [MonthlyReport] (MADR-002/007). Делаем руками — сгенерированный код не
/// правим.
///
/// Точка нормализации: строковые ключи `byType` (`WATERING`/`MISTING`/...) →
/// доменный [CareTaskType] (тот же enum, что у `/today` и `/calendar`).
/// Нераспознанные коды (`CareTaskType.unknown`) отбрасываем — экран отчёта
/// показывает только известные типы. `healthTrend` в контракте non-nullable
/// (required); пустой месяц приходит пустым списком, отдельной null-ветки нет.
extension MonthlyReportResponseMapper on MonthlyReportResponse {
  MonthlyReport toDomain() => MonthlyReport(
        month: month,
        done: done,
        overdue: overdue,
        byType: _byTypeToDomain(byType),
        streak: streak,
        healthTrend:
            healthTrend.map((bucket) => bucket.toDomain()).toList(growable: false),
      );

  /// Нормализует строковые ключи в [CareTaskType]; неизвестные коды
  /// (`unknown`) отбрасывает. Если backend пришлёт два разных строковых ключа,
  /// схлопывающихся в один enum (теоретически), значения суммируются.
  static Map<CareTaskType, int> _byTypeToDomain(Map<String, int> raw) {
    final result = <CareTaskType, int>{};
    for (final entry in raw.entries) {
      final type = CareTaskType.fromApi(entry.key);
      if (type == CareTaskType.unknown) continue;
      result.update(
        type,
        (existing) => existing + entry.value,
        ifAbsent: () => entry.value,
      );
    }
    return result;
  }
}

extension _WeeklyHealthBucketDtoMapper on dto.WeeklyHealthBucket {
  WeeklyHealthBucket toDomain() => WeeklyHealthBucket(
        week: week,
        done: done,
        // Клампим 0..1 на случай значения вне диапазона (генератор границы не
        // валидирует).
        onTimePct: onTimePct.clamp(0.0, 1.0),
      );
}
