// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_guest_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер кнопки «Продолжить без аккаунта».
///
/// Контракт для ui-builder:
/// - провайдер `authGuestControllerProvider` → [AuthGuestState];
/// - [signInAsGuest] — по нажатию кнопки; no-op, если запрос уже в полёте.
/// - По успеху контроллер не навигирует — router-guard сам уведёт с экрана
///   входа (сессия поднята).
/// - При ошибке — [AuthGuestState.error] заполняется (показываем snackbar).

@ProviderFor(AuthGuestController)
final authGuestControllerProvider = AuthGuestControllerProvider._();

/// Контроллер кнопки «Продолжить без аккаунта».
///
/// Контракт для ui-builder:
/// - провайдер `authGuestControllerProvider` → [AuthGuestState];
/// - [signInAsGuest] — по нажатию кнопки; no-op, если запрос уже в полёте.
/// - По успеху контроллер не навигирует — router-guard сам уведёт с экрана
///   входа (сессия поднята).
/// - При ошибке — [AuthGuestState.error] заполняется (показываем snackbar).
final class AuthGuestControllerProvider
    extends $NotifierProvider<AuthGuestController, AuthGuestState> {
  /// Контроллер кнопки «Продолжить без аккаунта».
  ///
  /// Контракт для ui-builder:
  /// - провайдер `authGuestControllerProvider` → [AuthGuestState];
  /// - [signInAsGuest] — по нажатию кнопки; no-op, если запрос уже в полёте.
  /// - По успеху контроллер не навигирует — router-guard сам уведёт с экрана
  ///   входа (сессия поднята).
  /// - При ошибке — [AuthGuestState.error] заполняется (показываем snackbar).
  AuthGuestControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authGuestControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authGuestControllerHash();

  @$internal
  @override
  AuthGuestController create() => AuthGuestController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthGuestState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthGuestState>(value),
    );
  }
}

String _$authGuestControllerHash() =>
    r'cb3ad53afb9410384d7e8d976f4bdf7e1b7d549c';

/// Контроллер кнопки «Продолжить без аккаунта».
///
/// Контракт для ui-builder:
/// - провайдер `authGuestControllerProvider` → [AuthGuestState];
/// - [signInAsGuest] — по нажатию кнопки; no-op, если запрос уже в полёте.
/// - По успеху контроллер не навигирует — router-guard сам уведёт с экрана
///   входа (сессия поднята).
/// - При ошибке — [AuthGuestState.error] заполняется (показываем snackbar).

abstract class _$AuthGuestController extends $Notifier<AuthGuestState> {
  AuthGuestState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthGuestState, AuthGuestState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthGuestState, AuthGuestState>,
              AuthGuestState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
