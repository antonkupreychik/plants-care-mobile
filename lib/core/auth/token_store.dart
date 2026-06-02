import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Пара JWT-токенов клиента (MADR-008). `accessToken` — короткоживущий, шлётся
/// в `Authorization: Bearer`; `refreshToken` — долгоживущий, обменивается на
/// новую пару через `/auth/refresh`.
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

/// Защищённое хранилище пары токенов (MADR-008) поверх
/// [FlutterSecureStorage] (Keychain/Keystore). Единственная точка персиста
/// auth — [JwtAuthSession] держит токены в памяти и пишет их сюда.
class TokenStore {
  const TokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'auth_access_token';
  static const _refreshKey = 'auth_refresh_token';

  /// Читает сохранённую пару. `null`, если хотя бы одного токена нет (неполная
  /// пара бесполезна — нечем ни авторизоваться, ни ротировать).
  Future<AuthTokens?> read() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    if (access == null || refresh == null) return null;
    return AuthTokens(accessToken: access, refreshToken: refresh);
  }

  Future<void> write(AuthTokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
