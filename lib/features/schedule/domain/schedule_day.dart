import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task.dart';

part 'schedule_day.freezed.dart';

/// Один день недельного графика (экран 11 «График»).
///
/// Чистый Dart: ни Flutter, ни Riverpod, ни dio. [date] — локальная дата
/// (полночь в TZ пользователя), идентифицирует ячейку календаря. [tasks] —
/// задачи на этот день в порядке backend (отсортированы по `dueAt`); пустой
/// список для дня без задач.
///
/// Признак «сегодня» и «просрочено» domain НЕ хранит — их выводит UI по
/// `clockProvider` (FLUTTER.md «Время»): domain не зависит от текущего момента.
@freezed
abstract class ScheduleDay with _$ScheduleDay {
  const factory ScheduleDay({
    /// Локальная дата (полночь). Совпадает с серверным ключом `YYYY-MM-DD`.
    required DateTime date,

    /// Задачи дня (пустой список = день без задач).
    required List<CareTask> tasks,
  }) = _ScheduleDay;
}
