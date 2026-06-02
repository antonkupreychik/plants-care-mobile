import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_session.dart';
import 'auth_status_notifier.dart';
import 'jwt_auth_session.dart';
import 'token_store.dart';

part 'auth_providers.g.dart';

/// Защищённое хранилище токенов (MADR-008). Реальный экземпляр проставляется
/// override'ом в `bootstrap()` (нужен async-доступ к Keychain/Keystore на
/// старте).
@riverpod
TokenStore tokenStore(Ref ref) =>
    throw UnimplementedError('tokenStoreProvider overridden in bootstrap()');

/// JWT-сессия (MADR-008) — единый держатель пары токенов. Создаётся в
/// `bootstrap()` уже с прочитанной из [TokenStore] парой (или dev-токеном из
/// `--dart-define`) и проставляется override'ом.
@riverpod
JwtAuthSession jwtAuthSession(Ref ref) =>
    throw UnimplementedError('jwtAuthSessionProvider overridden in bootstrap()');

/// Текущий auth-слот (MADR-008). За интерфейсом [AuthSession] — [JwtAuthSession];
/// сетевой слой/интерсепторы зависят только от интерфейса.
@riverpod
AuthSession authSession(Ref ref) => ref.watch(jwtAuthSessionProvider);

/// Реактивный флаг авторизации для router-guard (MADR-008). Стабильный
/// keepAlive-инстанс [AuthStatusNotifier], который слушает go_router через
/// `refreshListenable` (см. `appRouterProvider`). Стартовое значение берётся
/// из текущей сессии (на старте — есть ли валидная пара токенов в [TokenStore]
/// / dev-токен). Флипают флаг data-слой входа/выхода и
/// `RefreshInterceptor.onSessionExpired`.
@Riverpod(keepAlive: true)
AuthStatusNotifier authStatus(Ref ref) {
  final n = AuthStatusNotifier(ref.read(jwtAuthSessionProvider).isAuthenticated);
  ref.onDispose(n.dispose);
  return n;
}
