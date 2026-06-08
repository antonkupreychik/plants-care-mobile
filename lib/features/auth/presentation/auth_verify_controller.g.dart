// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_verify_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
/// Family по [token] (значение из query-параметра ссылки).
///
/// Контракт для ui-builder:
/// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
/// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
/// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.

@ProviderFor(AuthVerifyController)
final authVerifyControllerProvider = AuthVerifyControllerFamily._();

/// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
/// Family по [token] (значение из query-параметра ссылки).
///
/// Контракт для ui-builder:
/// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
/// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
/// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.
final class AuthVerifyControllerProvider
    extends $AsyncNotifierProvider<AuthVerifyController, void> {
  /// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
  /// Family по [token] (значение из query-параметра ссылки).
  ///
  /// Контракт для ui-builder:
  /// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
  /// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
  ///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
  ///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
  /// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.
  AuthVerifyControllerProvider._({
    required AuthVerifyControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'authVerifyControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authVerifyControllerHash();

  @override
  String toString() {
    return r'authVerifyControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AuthVerifyController create() => AuthVerifyController();

  @override
  bool operator ==(Object other) {
    return other is AuthVerifyControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authVerifyControllerHash() =>
    r'6d74bb7e08ae358891c915377912f25516769632';

/// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
/// Family по [token] (значение из query-параметра ссылки).
///
/// Контракт для ui-builder:
/// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
/// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
/// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.

final class AuthVerifyControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AuthVerifyController,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  AuthVerifyControllerFamily._()
    : super(
        retry: null,
        name: r'authVerifyControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
  /// Family по [token] (значение из query-параметра ссылки).
  ///
  /// Контракт для ui-builder:
  /// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
  /// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
  ///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
  ///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
  /// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.

  AuthVerifyControllerProvider call(String token) =>
      AuthVerifyControllerProvider._(argument: token, from: this);

  @override
  String toString() => r'authVerifyControllerProvider';
}

/// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
/// Family по [token] (значение из query-параметра ссылки).
///
/// Контракт для ui-builder:
/// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
/// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
/// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.

abstract class _$AuthVerifyController extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get token => _$args;

  FutureOr<void> build(String token);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
