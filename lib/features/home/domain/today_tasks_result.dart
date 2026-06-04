import '../../../core/care/care_task.dart';

/// Результат запроса `GET /today`: список задач + сводка прогресса.
///
/// Чистый Dart. [completedCount] и [totalCount] берутся из `TodaySummary`
/// бэкенда (поля `done` и `total`). Если бэкенд вернул оба поля,
/// процент завершения вычисляется как `completedCount / totalCount`.
///
/// Используется в [homeTasksProvider] для передачи прогресса в [TodayCard]
/// без дополнительного запроса к API.
class TodayTasksResult {
  const TodayTasksResult({
    required this.tasks,
    required this.completedCount,
    required this.totalCount,
  });

  final List<CareTask> tasks;

  /// Количество задач, выполненных сегодня (`TodaySummary.done`).
  final int completedCount;

  /// Всего задач сегодня (`TodaySummary.total`). Если 0 — прогресс не показываем.
  final int totalCount;

  /// Доля выполнения [0.0, 1.0]. `0.0` если [totalCount] == 0.
  double get progressFraction =>
      totalCount > 0 ? completedCount / totalCount : 0.0;

  /// Процент выполнения [0, 100]. `0` если [totalCount] == 0.
  int get progressPercent =>
      totalCount > 0 ? ((completedCount / totalCount) * 100).round() : 0;
}
