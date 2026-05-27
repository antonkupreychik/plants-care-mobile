import '../env/app_config.dart';
import '../network/auth_scope.dart';
import 'auth_session.dart';

/// Dev-реализация auth-слота (MADR-008): отдаёт PoC-заголовки
/// `X-User-Id` / `X-Chat-Id` из [AppConfig] (`--dart-define`). Только dev —
/// в prod значения null, и запросы идут без заголовков (до JWT).
class DevAuthSession implements AuthSession {
  const DevAuthSession(this._config);

  final AppConfig _config;

  @override
  Map<String, String> headersFor(AuthScope scope) => switch (scope) {
        AuthScope.user => {
            if (_config.userId != null) 'X-User-Id': _config.userId!,
          },
        AuthScope.chat => {
            if (_config.chatId != null) 'X-Chat-Id': _config.chatId!,
          },
        AuthScope.none => const {},
      };

  @override
  bool get isAuthenticated =>
      _config.userId != null || _config.chatId != null;
}
