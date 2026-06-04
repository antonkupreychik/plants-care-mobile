import '../../../core/error/result.dart';
import 'care_event_draft.dart';
import 'logged_care_event.dart';

/// Контракт data-слоя для записи действия ухода (`POST /care-events`,
/// scope chat). Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011).
abstract interface class CareEventRepository {
  /// Регистрирует событие ухода. Идемпотентно по `CareEventDraft.clientId`
  /// (повтор с тем же clientId не создаёт дубль — backend дедуплицирует).
  Future<Result<LoggedCareEvent>> logCareEvent(CareEventDraft draft);

  /// Количество уже записанных событий ухода растения ДО текущего действия.
  ///
  /// Используется для детекции «первого ухода» (экран 33 «Успех первого
  /// ухода»): читает `GET /plants/{id}/history` с минимальной страницей
  /// (`limit: 1, offset: 0`) и возвращает `total` — общее число активных
  /// записей. `0` означает, что текущее действие будет первым.
  ///
  /// Тот же scope chat, что у чтения истории (`X-Chat-Id`). НЕ бросает наружу
  /// (MADR-011): ошибку возвращает как `Result.failure` — вызывающий
  /// деградирует тихо (без празднования), а не падает.
  Future<Result<int>> priorCareEventCount(int plantId);
}
