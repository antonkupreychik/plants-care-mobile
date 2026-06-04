import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task_type.dart';
import 'weekly_health_bucket.dart';

part 'monthly_report.freezed.dart';

/// Доменная модель «Месячный отчёт по уходу» (экран 14).
///
/// Источник — `GET /reports/monthly` (`MonthlyReportResponse`). Агрегаты за
/// календарный месяц посчитаны backend (сделано/просрочено, разбивка по типам,
/// стрик, понедельный тренд); клиент их НЕ пересчитывает (FLUTTER.md «Время и
/// расчёты»).
///
/// [byType] нормализована в доменный [CareTaskType] (тот же enum, что у
/// `/today` и `/calendar`) — нормализацию строковых ключей делает маппер
/// data-слоя (MADR-002). Разбивки по растениям и «звёзд месяца» backend не
/// отдаёт — в модели их нет (логируется как backend-gap отдельно).
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    /// Месяц отчёта `YYYY-MM` (например, `2026-05`).
    required String month,

    /// Всего выполненных задач ухода за месяц.
    required int done,

    /// Всего просроченных (невыполненных в срок) задач за месяц.
    required int overdue,

    /// Разбивка выполненных задач по типу ухода. Ключ — доменный
    /// [CareTaskType] (нераспознанные backend-коды отброшены маппером).
    required Map<CareTaskType, int> byType,

    /// Текущий стрик (выполнений вовремя подряд).
    required int streak,

    /// Понедельный тренд за месяц (выполнено + доля вовремя).
    required List<WeeklyHealthBucket> healthTrend,
  }) = _MonthlyReport;

  const MonthlyReport._();

  /// Общий процент выполненных вовремя за месяц — взвешенное среднее по
  /// [healthTrend]: `sum(done_w * onTimePct_w) / sum(done_w)`.
  ///
  /// Возвращает `null`, если суммарно за месяц нет выполненных задач
  /// (`sum done == 0`) — данных для процента нет, UI не рисует значение.
  /// Значение в диапазоне [0, 1].
  double? get onTimePct {
    var totalDone = 0;
    var weightedSum = 0.0;
    for (final bucket in healthTrend) {
      totalDone += bucket.done;
      weightedSum += bucket.done * bucket.onTimePct;
    }
    if (totalDone == 0) return null;
    return weightedSum / totalDone;
  }

  /// За месяц нет активности (ни выполнений, ни просрочек) — UI показывает
  /// empty-state экрана отчёта.
  bool get isEmpty => done == 0 && overdue == 0;
}
