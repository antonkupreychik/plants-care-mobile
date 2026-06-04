import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../edit_schedule/data/edit_schedule_repository_provider.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../data/care_event_repository_provider.dart';
import '../data/mappers/task_type_mapper.dart';
import '../domain/count_prior_care_events.dart';
import '../domain/log_care_event.dart';

part 'care_event_providers.g.dart';

/// DI-точка use case [LogCareEvent] (MADR-004: граф провайдеров = DI).
/// Notifier зовёт use case, а не репозиторий напрямую (MADR-002).
@riverpod
LogCareEvent logCareEvent(Ref ref) =>
    LogCareEvent(ref.watch(careEventRepositoryProvider));

/// DI-точка use case [CountPriorCareEvents] — детекция «первого ухода»
/// (экран 33). Notifier зовёт use case, а не репозиторий напрямую (MADR-002).
@riverpod
CountPriorCareEvents countPriorCareEvents(Ref ref) =>
    CountPriorCareEvents(ref.watch(careEventRepositoryProvider));

/// Список типов ухода, которые включены у данного растения.
///
/// Загружает расписания (`GET /plants/{id}/schedules`) и возвращает только
/// те [CareEventKind], у которых `enabled: true`. [CareEventKind.unknown]
/// (SOIL_CHECK и нераспознанные типы) исключается — REST не принимает.
///
/// При ошибке загрузки деградирует на все три типа, чтобы не блокировать
/// отметку ухода. Пустой enabled-список (все выключены) тоже даёт fallback.
@riverpod
Future<List<CareEventKind>> enabledCareKinds(Ref ref, int plantId) async {
  final result =
      await ref.watch(editScheduleRepositoryProvider).getSchedules(plantId);
  if (result is! Success) {
    return [CareEventKind.water, CareEventKind.spray, CareEventKind.fertilize];
  }
  final enabled = (result as Success).value
      .where((s) => s.enabled)
      .map((s) => careEventKindFromTaskType(s.type))
      .where((k) => k != CareEventKind.unknown)
      .toList();
  return enabled.isNotEmpty
      ? enabled
      : [CareEventKind.water, CareEventKind.spray, CareEventKind.fertilize];
}
