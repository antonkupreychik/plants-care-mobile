import 'package:dio/dio.dart';

import '../api/generated/clients/auth_client.dart';
import '../api/generated/models/refresh_request.dart';
import '../auth/jwt_auth_session.dart';
import '../auth/token_store.dart';

/// Прозрачная ротация на `401` (MADR-008). При истёкшем access-токене:
/// 1. обменивает refresh на новую пару через `/auth/refresh`,
/// 2. сохраняет её в [JwtAuthSession] (память + персист),
/// 3. повторяет исходный запрос один раз (новый bearer подставит
///    `AuthInterceptor` при повторном проходе через основной [Dio]).
///
/// Защита от рекурсии: вызов `/auth/refresh` идёт через **отдельный «голый»**
/// [AuthClient] (без auth/refresh-интерсепторов), а повтор помечается
/// `extra[_retriedKey]` — второй `401` подряд уже не рефрешим.
///
/// Параллельные `401` коллапсируют в **один** refresh через single-flight
/// [_inflight]: при ротации старый refresh отзывается, и второй обмен тем же
/// токеном получил бы `401 TOKEN_REVOKED`.
///
/// Невозвратный отказ (нет refresh / refresh отклонён) → [JwtAuthSession.clear]
/// + опциональный [onSessionExpired] (для router-guard среза 2); исходная
/// ошибка пробрасывается дальше в [ErrorInterceptor].
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({
    required JwtAuthSession session,
    required AuthClient refreshClient,
    required Dio retryDio,
    this.onSessionExpired,
  })  : _session = session, // ignore: prefer_initializing_formals
        _refreshClient = refreshClient, // ignore: prefer_initializing_formals
        _retryDio = retryDio; // ignore: prefer_initializing_formals

  final JwtAuthSession _session;
  final AuthClient _refreshClient;
  final Dio _retryDio;
  final void Function()? onSessionExpired;

  static const _retriedKey = 'authRetried';

  Future<bool>? _inflight;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRefresh(err)) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshOnce();
    if (!refreshed) {
      await _session.clear();
      onSessionExpired?.call();
      handler.next(err);
      return;
    }

    try {
      final options = err.requestOptions..extra[_retriedKey] = true;
      final response = await _retryDio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }

  bool _shouldRefresh(DioException err) {
    if (err.response?.statusCode != 401) return false;
    if (err.requestOptions.extra[_retriedKey] == true) return false;
    // Сами auth-эндпоинты не рефрешим (их 401 — это и есть отказ входа/ротации).
    if (err.requestOptions.path.contains('/api/v1/auth/')) return false;
    return _session.refreshToken != null;
  }

  /// Single-flight: конкурентные `401` ждут один и тот же обмен.
  Future<bool> _refreshOnce() {
    return _inflight ??= _performRefresh().whenComplete(() => _inflight = null);
  }

  Future<bool> _performRefresh() async {
    final refresh = _session.refreshToken;
    if (refresh == null) return false;
    try {
      final pair = await _refreshClient.refreshTokens(
        body: RefreshRequest(refreshToken: refresh),
      );
      await _session.updateTokens(
        AuthTokens(
          accessToken: pair.accessToken,
          refreshToken: pair.refreshToken,
        ),
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
