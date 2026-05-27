import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_task_type.dart';

part 'care_task.freezed.dart';

/// Доменная задача ухода на сегодня (источник — `GET /today`, [TaskDto]).
///
/// Чистый Dart: ни Flutter, ни Riverpod, ни dio. Время — UTC (как с backend);
/// в TZ пользователя его переводит UI. Группировку «утро/вечер» по [dueAt]
/// тоже делает presentation/UI — domain не считает интервалы (FLUTTER.md «Время»).
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
  }) = _CareTask;
}
