import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/care/care_task_type.dart';
import '../../../core/error/result.dart';
import '../../edit_schedule/data/edit_schedule_repository_provider.dart';
import '../../edit_schedule/domain/plant_care_schedule.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../data/mappers/task_type_mapper.dart';

part 'next_care_due_provider.g.dart';

/// Read-only список расписаний растения для экрана 33 «Успех первого ухода»
/// (`GET /plants/{id}/schedules`, user-scoped внутри репозитория, G19).
///
/// Лёгкий потребительский провайдер: экран 33 лишь читает расписания ради
/// `nextDueAt` и НЕ редактирует их, поэтому он не тянет `EditScheduleController`
/// с его draft/dirty/save (тот заточен под экран 22). Реюз репозитория —
/// [editScheduleRepositoryProvider], свой код запроса не дублируем.
///
/// Разворачиваем [Result] репозитория (MADR-011) в [AsyncValue]:
/// - `Success` → данные;
/// - `Failure` → пробрасываем в `AsyncError` (экран 33 деградирует мягко: уход
///   уже записан, счётчик просто не показываем).
@riverpod
Future<List<PlantCareSchedule>> plantSchedules(Ref ref, int plantId) async {
  final repo = ref.watch(editScheduleRepositoryProvider);
  final result = await repo.getSchedules(plantId);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}

/// Момент следующего ухода (`nextDueAt`, UTC, посчитан backend) для расписания,
/// соответствующего выполненному типу [kind] на экране 33.
///
/// Возвращает `null` (счётчик скрывается), если:
/// - [kind] == [CareEventKind.unknown] — публичного→внутреннего типа нет;
/// - подходящего расписания в ответе нет;
/// - расписание **выключено** (`enabled == false`) — задачи не генерирует,
///   следующего ухода нет, даже если backend прислал какое-то `nextDueAt`;
/// - у расписания `nextDueAt == null` (срок не определён).
///
/// Чистая функция (без Flutter/Riverpod) — удобна для unit-теста; провайдер
/// [nextCareDueProvider] лишь оборачивает её над [plantSchedules].
DateTime? nextDueForKind(List<PlantCareSchedule> schedules, CareEventKind kind) {
  final type = careTaskTypeFromCareEventKind(kind);
  if (type == CareTaskType.unknown) return null;

  for (final s in schedules) {
    if (s.type != type) continue;
    if (!s.enabled) return null;
    return s.nextDueAt;
  }
  return null;
}

/// Derived-провайдер для футера экрана 33: момент следующего ухода для
/// записанного типа [kind] растения [plantId].
///
/// `AsyncValue<DateTime?>`:
/// - `loading` — пока грузятся расписания;
/// - `data(null)` — расписания не дают срока (выключено / unknown / нет
///   совпадения / `nextDueAt == null`): UI счётчик НЕ показывает;
/// - `data(dateTime)` — UTC-момент; форматирование «через N дн.» делает UI
///   (`nextDueLabel`, относительно инжектируемого Clock-«сейчас»);
/// - upstream-`Failure` ([plantSchedules]) → derived остаётся в **не-`data`**
///   состоянии (на текущей версии Riverpod `await ref.watch(.future)` держит
///   его в `loading`, не ретранслируя в `error`). Гарантируется лишь инвариант
///   «никогда не `data(non-null)` при упавшем запросе» — UI на любое не-`data`
///   (`loading`/`error`) одинаково деградирует мягко (счётчик скрыт, generic-хинт).
@riverpod
Future<DateTime?> nextCareDue(
  Ref ref, {
  required int plantId,
  required CareEventKind kind,
}) async {
  final schedules = await ref.watch(plantSchedulesProvider(plantId).future);
  return nextDueForKind(schedules, kind);
}
