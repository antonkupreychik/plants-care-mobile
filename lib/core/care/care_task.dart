import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_task_type.dart';

part 'care_task.freezed.dart';

/// Доменная задача ухода (источник — `TaskDto` из `/today` и `/calendar`).
///
/// Чистый Dart: ни Flutter, ни Riverpod, ни dio. Время — UTC (как с backend);
/// в TZ пользователя его переводит UI. Группировку «утро/вечер» по [dueAt]
/// тоже делает presentation/UI — domain не считает интервалы (FLUTTER.md «Время»).
///
/// Общая модель двух фич (home/schedule) → живёт в `core/care/`.
@freezed
abstract class CareTask with _$CareTask {
  const factory CareTask({
    /// Идентификатор расписания, породившего задачу (`TaskDto.scheduleId`).
    required int scheduleId,

    /// Растение, к которому относится задача.
    required int plantId,
    required String plantName,

    /// Нормализованный тип ухода (см. [CareTaskType]).
    required CareTaskType type,

    /// Дедлайн задачи в UTC.
    required DateTime dueAt,

    /// Денормализованное имя локации (если backend прислал).
    String? locationName,

    /// Идентификатор вида растения (`Species.id`).
    ///
    /// Нужен UI для выбора SVG-иллюстрации (BACKEND-GAPS G6). Nullable:
    /// у растения может не быть привязанного вида.
    int? speciesId,

    /// Имя вида растения (для иллюстрации/подписи в UI, G6). Nullable.
    String? speciesName,
  }) = _CareTask;
}
