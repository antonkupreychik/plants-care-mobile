// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_social_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер кнопок социального входа (Google / Apple).
///
/// Контракт для ui-builder:
/// - провайдер `authSocialControllerProvider` → [AuthSocialState];
/// - [google] / [apple] — по нажатию соответствующей кнопки; no-op, если запрос
///   уже в полёте ([AuthSocialState.isBusy]). На время запроса
///   `inProgress` = провайдер (UI рисует индикатор и блокирует кнопки).
/// - По успеху контроллер ничего не навигирует — router-guard уведёт с экрана
///   входа сам (сессия уже поднята); `inProgress` сбрасывается.
/// - Отмена пользователем — тихий сброс `inProgress`, ошибка НЕ показывается.
/// - Ошибка — `error` заполнен, `inProgress` сброшен.

@ProviderFor(AuthSocialController)
final authSocialControllerProvider = AuthSocialControllerProvider._();

/// Контроллер кнопок социального входа (Google / Apple).
///
/// Контракт для ui-builder:
/// - провайдер `authSocialControllerProvider` → [AuthSocialState];
/// - [google] / [apple] — по нажатию соответствующей кнопки; no-op, если запрос
///   уже в полёте ([AuthSocialState.isBusy]). На время запроса
///   `inProgress` = провайдер (UI рисует индикатор и блокирует кнопки).
/// - По успеху контроллер ничего не навигирует — router-guard уведёт с экрана
///   входа сам (сессия уже поднята); `inProgress` сбрасывается.
/// - Отмена пользователем — тихий сброс `inProgress`, ошибка НЕ показывается.
/// - Ошибка — `error` заполнен, `inProgress` сброшен.
final class AuthSocialControllerProvider
    extends $NotifierProvider<AuthSocialController, AuthSocialState> {
  /// Контроллер кнопок социального входа (Google / Apple).
  ///
  /// Контракт для ui-builder:
  /// - провайдер `authSocialControllerProvider` → [AuthSocialState];
  /// - [google] / [apple] — по нажатию соответствующей кнопки; no-op, если запрос
  ///   уже в полёте ([AuthSocialState.isBusy]). На время запроса
  ///   `inProgress` = провайдер (UI рисует индикатор и блокирует кнопки).
  /// - По успеху контроллер ничего не навигирует — router-guard уведёт с экрана
  ///   входа сам (сессия уже поднята); `inProgress` сбрасывается.
  /// - Отмена пользователем — тихий сброс `inProgress`, ошибка НЕ показывается.
  /// - Ошибка — `error` заполнен, `inProgress` сброшен.
  AuthSocialControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSocialControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSocialControllerHash();

  @$internal
  @override
  AuthSocialController create() => AuthSocialController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSocialState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSocialState>(value),
    );
  }
}

String _$authSocialControllerHash() =>
    r'824a87e414ed27b82ecfb8d5ce24ae6017d6b90e';

/// Контроллер кнопок социального входа (Google / Apple).
///
/// Контракт для ui-builder:
/// - провайдер `authSocialControllerProvider` → [AuthSocialState];
/// - [google] / [apple] — по нажатию соответствующей кнопки; no-op, если запрос
///   уже в полёте ([AuthSocialState.isBusy]). На время запроса
///   `inProgress` = провайдер (UI рисует индикатор и блокирует кнопки).
/// - По успеху контроллер ничего не навигирует — router-guard уведёт с экрана
///   входа сам (сессия уже поднята); `inProgress` сбрасывается.
/// - Отмена пользователем — тихий сброс `inProgress`, ошибка НЕ показывается.
/// - Ошибка — `error` заполнен, `inProgress` сброшен.

abstract class _$AuthSocialController extends $Notifier<AuthSocialState> {
  AuthSocialState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthSocialState, AuthSocialState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthSocialState, AuthSocialState>,
              AuthSocialState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
