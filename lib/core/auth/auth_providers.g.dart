// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Защищённое хранилище токенов (MADR-008). Реальный экземпляр проставляется
/// override'ом в `bootstrap()` (нужен async-доступ к Keychain/Keystore на
/// старте).

@ProviderFor(tokenStore)
final tokenStoreProvider = TokenStoreProvider._();

/// Защищённое хранилище токенов (MADR-008). Реальный экземпляр проставляется
/// override'ом в `bootstrap()` (нужен async-доступ к Keychain/Keystore на
/// старте).

final class TokenStoreProvider
    extends $FunctionalProvider<TokenStore, TokenStore, TokenStore>
    with $Provider<TokenStore> {
  /// Защищённое хранилище токенов (MADR-008). Реальный экземпляр проставляется
  /// override'ом в `bootstrap()` (нужен async-доступ к Keychain/Keystore на
  /// старте).
  TokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStoreHash();

  @$internal
  @override
  $ProviderElement<TokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStore create(Ref ref) {
    return tokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStore>(value),
    );
  }
}

String _$tokenStoreHash() => r'132b2bfbb4c378899756bb02ea51b8f0708e2c3f';

/// JWT-сессия (MADR-008) — единый держатель пары токенов. Создаётся в
/// `bootstrap()` уже с прочитанной из [TokenStore] парой (или dev-токеном из
/// `--dart-define`) и проставляется override'ом.

@ProviderFor(jwtAuthSession)
final jwtAuthSessionProvider = JwtAuthSessionProvider._();

/// JWT-сессия (MADR-008) — единый держатель пары токенов. Создаётся в
/// `bootstrap()` уже с прочитанной из [TokenStore] парой (или dev-токеном из
/// `--dart-define`) и проставляется override'ом.

final class JwtAuthSessionProvider
    extends $FunctionalProvider<JwtAuthSession, JwtAuthSession, JwtAuthSession>
    with $Provider<JwtAuthSession> {
  /// JWT-сессия (MADR-008) — единый держатель пары токенов. Создаётся в
  /// `bootstrap()` уже с прочитанной из [TokenStore] парой (или dev-токеном из
  /// `--dart-define`) и проставляется override'ом.
  JwtAuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jwtAuthSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jwtAuthSessionHash();

  @$internal
  @override
  $ProviderElement<JwtAuthSession> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JwtAuthSession create(Ref ref) {
    return jwtAuthSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JwtAuthSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JwtAuthSession>(value),
    );
  }
}

String _$jwtAuthSessionHash() => r'dbf77a5c61acc2691140f79729bb5dbb682fde86';

/// Текущий auth-слот (MADR-008). За интерфейсом [AuthSession] — [JwtAuthSession];
/// сетевой слой/интерсепторы зависят только от интерфейса.

@ProviderFor(authSession)
final authSessionProvider = AuthSessionProvider._();

/// Текущий auth-слот (MADR-008). За интерфейсом [AuthSession] — [JwtAuthSession];
/// сетевой слой/интерсепторы зависят только от интерфейса.

final class AuthSessionProvider
    extends $FunctionalProvider<AuthSession, AuthSession, AuthSession>
    with $Provider<AuthSession> {
  /// Текущий auth-слот (MADR-008). За интерфейсом [AuthSession] — [JwtAuthSession];
  /// сетевой слой/интерсепторы зависят только от интерфейса.
  AuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionHash();

  @$internal
  @override
  $ProviderElement<AuthSession> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthSession create(Ref ref) {
    return authSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSession>(value),
    );
  }
}

String _$authSessionHash() => r'93aa61bfaba19610e1741a3d18528ac412a48390';

/// Реактивный флаг авторизации для router-guard (MADR-008). Стабильный
/// keepAlive-инстанс [AuthStatusNotifier], который слушает go_router через
/// `refreshListenable` (см. `appRouterProvider`). Стартовое значение берётся
/// из текущей сессии (на старте — есть ли валидная пара токенов в [TokenStore]
/// / dev-токен). Флипают флаг data-слой входа/выхода и
/// `RefreshInterceptor.onSessionExpired`.

@ProviderFor(authStatus)
final authStatusProvider = AuthStatusProvider._();

/// Реактивный флаг авторизации для router-guard (MADR-008). Стабильный
/// keepAlive-инстанс [AuthStatusNotifier], который слушает go_router через
/// `refreshListenable` (см. `appRouterProvider`). Стартовое значение берётся
/// из текущей сессии (на старте — есть ли валидная пара токенов в [TokenStore]
/// / dev-токен). Флипают флаг data-слой входа/выхода и
/// `RefreshInterceptor.onSessionExpired`.

final class AuthStatusProvider
    extends
        $FunctionalProvider<
          AuthStatusNotifier,
          AuthStatusNotifier,
          AuthStatusNotifier
        >
    with $Provider<AuthStatusNotifier> {
  /// Реактивный флаг авторизации для router-guard (MADR-008). Стабильный
  /// keepAlive-инстанс [AuthStatusNotifier], который слушает go_router через
  /// `refreshListenable` (см. `appRouterProvider`). Стартовое значение берётся
  /// из текущей сессии (на старте — есть ли валидная пара токенов в [TokenStore]
  /// / dev-токен). Флипают флаг data-слой входа/выхода и
  /// `RefreshInterceptor.onSessionExpired`.
  AuthStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStatusHash();

  @$internal
  @override
  $ProviderElement<AuthStatusNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthStatusNotifier create(Ref ref) {
    return authStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStatusNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStatusNotifier>(value),
    );
  }
}

String _$authStatusHash() => r'f4ddbeecb92778f8f2b011a0b3083222e9b2343d';
