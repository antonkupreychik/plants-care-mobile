import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_health_bucket.freezed.dart';

/// Доменная модель «понедельный агрегат» месячного отчёта (экран 14).
///
/// Источник — `WeeklyHealthBucket` из `GET /reports/monthly`. Все значения
/// посчитаны backend; клиент их НЕ пересчитывает (FLUTTER.md «Время и расчёты»).
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class WeeklyHealthBucket with _$WeeklyHealthBucket {
  const factory WeeklyHealthBucket({
    /// ISO-неделя `YYYY-Www` (например, `2026-W19`).
    required String week,

    /// Выполнено задач за неделю.
    required int done,

    /// Доля выполненных вовремя [0, 1].
    required double onTimePct,
  }) = _WeeklyHealthBucket;
}
