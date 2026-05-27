// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Текущая сессия (MADR-008). Сейчас всегда dev-слот; при появлении JWT —
/// ветка на `JwtAuthSession`, остальной код не меняется.

@ProviderFor(authSession)
final authSessionProvider = AuthSessionProvider._();

/// Текущая сессия (MADR-008). Сейчас всегда dev-слот; при появлении JWT —
/// ветка на `JwtAuthSession`, остальной код не меняется.

final class AuthSessionProvider
    extends $FunctionalProvider<AuthSession, AuthSession, AuthSession>
    with $Provider<AuthSession> {
  /// Текущая сессия (MADR-008). Сейчас всегда dev-слот; при появлении JWT —
  /// ветка на `JwtAuthSession`, остальной код не меняется.
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

String _$authSessionHash() => r'45bf3af3c65b4bff4c9f454b33b58f2c9749fd51';
