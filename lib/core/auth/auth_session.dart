import '../network/auth_scope.dart';

/// Подключаемый слот идентичности (MADR-008). За этим интерфейсом прячется
/// источник auth: сейчас dev-заголовки ([DevAuthSession]), позже —
/// JWT-реализация (Telegram magic-link). Подмена реализации не трогает
/// экраны/репозитории/сетевой слой.
abstract interface class AuthSession {
  /// Заголовки для запроса данного [scope] (см. [AuthScope]).
  Map<String, String> headersFor(AuthScope scope);

  bool get isAuthenticated;
}
