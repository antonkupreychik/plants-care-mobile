import '../../../core/error/result.dart';
import 'care_event_draft.dart';
import 'care_event_repository.dart';
import 'logged_care_event.dart';

/// Use case: записать действие ухода (экран 06 sheet).
///
/// Одна ответственность, один публичный метод (MADR-002). Сейчас это тонкая
/// делегация в репозиторий — слой существует, чтобы presentation не зависел от
/// репозитория напрямую и чтобы будущая логика (offline-очередь, валидация
/// backdating) жила в domain, а не в Notifier.
class LogCareEvent {
  const LogCareEvent(this._repository);

  final CareEventRepository _repository;

  /// Регистрирует уход по черновику. Идемпотентно по `draft.clientId`.
  Future<Result<LoggedCareEvent>> call(CareEventDraft draft) =>
      _repository.logCareEvent(draft);
}
