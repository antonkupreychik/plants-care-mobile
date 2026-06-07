// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [AuthRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `authRepositoryProvider.overrideWith(...)`.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// DI-точка для [AuthRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `authRepositoryProvider.overrideWith(...)`.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// DI-точка для [AuthRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `authRepositoryProvider.overrideWith(...)`.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'e5176b205c68137eb11e1168396ed01ccedd4d0a';
