import '../../../core/error/result.dart';
import 'care_event_draft.dart';
import 'logged_care_event.dart';

/// Контракт data-слоя для записи действия ухода (`POST /care-events`,
/// scope chat). Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011).
abstract interface class CareEventRepository {
  /// Регистрирует событие ухода. Идемпотентно по `CareEventDraft.clientId`
  /// (повтор с тем же clientId не создаёт дубль — backend дедуплицирует).
  Future<Result<LoggedCareEvent>> logCareEvent(CareEventDraft draft);
}
