import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_history_summary.freezed.dart';

/// Сводка истории ухода для шапки экрана 21 (всего / вовремя% / стрик).
///
/// Чистый Dart. Считается из УЖЕ ЗАГРУЖЕННЫХ записей плюс backend-стрика
/// (`Streak.count`).
///
/// **Backend-gap (G29):** «вовремя %» по ВСЕЙ истории требует серверного
/// агрегата — его в API нет. Поэтому процент здесь считается по
/// [loadedCount] (загруженным записям), а не по [total]. Пока загружены не
/// все страницы, процент приблизителен — UI это учитывает (показывает по
/// загруженным). [total] держим отдельно, чтобы UI мог отличить «всего
/// записей» от «учтено в проценте».
@freezed
abstract class CareHistorySummary with _$CareHistorySummary {
  const factory CareHistorySummary({
    /// Всего записей истории (из `PlantHistoryResponse.total`).
    required int total,

    /// Сколько из ЗАГРУЖЕННЫХ записей выполнено «вовремя» (`onTime == true`).
    required int onTimeCount,

    /// Сколько записей реально загружено (база для [onTimePercent]).
    required int loadedCount,

    /// Текущий стрик on-time-уходов подряд (посчитан backend, `Streak.count`).
    required int streakCount,
  }) = _CareHistorySummary;

  const CareHistorySummary._();

  /// Доля «вовремя» среди ЗАГРУЖЕННЫХ записей, 0..100 (целое).
  /// При [loadedCount] == 0 → 0 (нет данных — не делим на ноль).
  ///
  /// Считается по [loadedCount], а не по [total] (см. G29): пока не все
  /// страницы загружены, значение приблизительно.
  int get onTimePercent =>
      loadedCount == 0 ? 0 : (onTimeCount * 100 / loadedCount).round();
}
