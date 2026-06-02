import '../network/auth_scope.dart';
import 'auth_session.dart';
import 'token_store.dart';

/// JWT-реализация auth-слота (MADR-008). Держит пару токенов в памяти и отдаёт
/// `Authorization: Bearer <access>` для аутентифицированных запросов; персист —
/// в [TokenStore]. Единый источник идентичности: интерсепторы и refresh-логика
/// работают через этот объект, экраны/репозитории его не знают.
///
/// [AuthScope.user] и [AuthScope.chat] теперь неразличимы (бэкенд резолвит
/// пользователя из `sub` токена) — оба дают bearer; [AuthScope.none] остаётся
/// без заголовка (публичные `/species`, `/care-types`, `/health`).
class JwtAuthSession implements AuthSession {
  JwtAuthSession(this._store, {AuthTokens? initial}) : _tokens = initial;

  final TokenStore _store;
  AuthTokens? _tokens;

  @override
  Map<String, String> headersFor(AuthScope scope) {
    final access = _tokens?.accessToken;
    if (access == null) return const {};
    return switch (scope) {
      AuthScope.user || AuthScope.chat => {'Authorization': 'Bearer $access'},
      AuthScope.none => const {},
    };
  }

  @override
  bool get isAuthenticated => _tokens != null;

  /// Refresh-токен для ротации (нужен [RefreshInterceptor]); `null`, если не
  /// аутентифицированы.
  String? get refreshToken => _tokens?.refreshToken;

  /// Принять новую пару (вход или ротация): обновляет память и персист.
  Future<void> updateTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await _store.write(tokens);
  }

  /// Сбросить сессию (logout / невозвратный отказ refresh): чистит память и
  /// персист — после рестарта мёртвый токен не подхватится.
  Future<void> clear() async {
    _tokens = null;
    await _store.clear();
  }
}
