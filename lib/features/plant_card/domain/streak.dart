import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak.freezed.dart';

/// Доменная модель стрика растения (источник — `GET /stats/streak`,
/// `StreakResponse`).
///
/// Чистый Dart. `count` — количество подряд выполненных «в срок» уходов
/// (`on_time = true`), посчитанное backend; клиент его не пересчитывает.
@freezed
abstract class Streak with _$Streak {
  const factory Streak({
    required int plantId,

    /// Количество on-time-уходов подряд.
    required int count,
  }) = _Streak;
}
