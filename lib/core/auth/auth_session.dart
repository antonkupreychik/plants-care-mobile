import '../network/auth_scope.dart';

/// Подключаемый слот идентичности (MADR-008). За этим интерфейсом прячется
/// источник auth: сейчас JWT-пара токенов ([JwtAuthSession], даёт
/// `Authorization: Bearer`); UI входа (Telegram magic-link / OAuth) — срез 2.
/// Подмена реализации не трогает экраны/репозитории/сетевой слой.
abstract interface class AuthSession {
  /// Заголовки для запроса данного [scope] (см. [AuthScope]).
  Map<String, String> headersFor(AuthScope scope);

  bool get isAuthenticated;
}
