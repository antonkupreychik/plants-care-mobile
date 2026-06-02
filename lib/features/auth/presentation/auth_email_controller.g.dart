// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_email_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана запроса magic link (ввод email).
///
/// Контракт для ui-builder:
/// - провайдер `authEmailControllerProvider` → [AuthEmailState].
/// - [setEmail] — на каждый ввод (сбрасывает прошлую ошибку).
/// - [submit] — по кнопке «Получить ссылку»; no-op, если `!state.canSubmit`.
///   По успеху `linkSent = true` (UI рисует «проверьте почту»), по ошибке —
///   `error` заполнен.

@ProviderFor(AuthEmailController)
final authEmailControllerProvider = AuthEmailControllerProvider._();

/// Контроллер экрана запроса magic link (ввод email).
///
/// Контракт для ui-builder:
/// - провайдер `authEmailControllerProvider` → [AuthEmailState].
/// - [setEmail] — на каждый ввод (сбрасывает прошлую ошибку).
/// - [submit] — по кнопке «Получить ссылку»; no-op, если `!state.canSubmit`.
///   По успеху `linkSent = true` (UI рисует «проверьте почту»), по ошибке —
///   `error` заполнен.
final class AuthEmailControllerProvider
    extends $NotifierProvider<AuthEmailController, AuthEmailState> {
  /// Контроллер экрана запроса magic link (ввод email).
  ///
  /// Контракт для ui-builder:
  /// - провайдер `authEmailControllerProvider` → [AuthEmailState].
  /// - [setEmail] — на каждый ввод (сбрасывает прошлую ошибку).
  /// - [submit] — по кнопке «Получить ссылку»; no-op, если `!state.canSubmit`.
  ///   По успеху `linkSent = true` (UI рисует «проверьте почту»), по ошибке —
  ///   `error` заполнен.
  AuthEmailControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authEmailControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authEmailControllerHash();

  @$internal
  @override
  AuthEmailController create() => AuthEmailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthEmailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthEmailState>(value),
    );
  }
}

String _$authEmailControllerHash() =>
    r'49f3388c9b6a536f7a79ea489b6e35061792941c';

/// Контроллер экрана запроса magic link (ввод email).
///
/// Контракт для ui-builder:
/// - провайдер `authEmailControllerProvider` → [AuthEmailState].
/// - [setEmail] — на каждый ввод (сбрасывает прошлую ошибку).
/// - [submit] — по кнопке «Получить ссылку»; no-op, если `!state.canSubmit`.
///   По успеху `linkSent = true` (UI рисует «проверьте почту»), по ошибке —
///   `error` заполнен.

abstract class _$AuthEmailController extends $Notifier<AuthEmailState> {
  AuthEmailState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthEmailState, AuthEmailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthEmailState, AuthEmailState>,
              AuthEmailState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
