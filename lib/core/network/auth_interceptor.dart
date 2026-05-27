import 'package:dio/dio.dart';

import '../auth/auth_session.dart';
import 'auth_scope.dart';
import 'request_extra.dart';

/// Подставляет PoC-заголовок по [AuthScope] из `options.extra` (MADR-006).
/// Выбор заголовка — по per-request флагу, НЕ по URL: так переход на JWT
/// меняет только [AuthSession], а не каждый data source.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._session);

  final AuthSession _session;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final scope = options.extra[kAuthScopeExtraKey];
    final resolved = scope is AuthScope ? scope : AuthScope.none;
    options.headers.addAll(_session.headersFor(resolved));
    handler.next(options);
  }
}
