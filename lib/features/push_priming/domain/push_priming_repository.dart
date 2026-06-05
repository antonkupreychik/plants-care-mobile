import 'push_priming_decision.dart';

/// Хранилище решения пользователя по праймингу пуш-уведомлений (экран 27).
///
/// Только локальный персист намерения — без сети. Серверная регистрация
/// устройства (`POST /api/v1/devices`) появится отдельной задачей после
/// решения по push-стеку (README §9 #3) и эндпоинта на бэкенде (backend #187).
abstract interface class PushPrimingRepository {
  /// Текущее сохранённое решение; [PushPrimingDecision.notDecided] по умолчанию.
  Future<PushPrimingDecision> getDecision();

  /// Сохраняет решение пользователя.
  Future<void> saveDecision(PushPrimingDecision decision);
}
