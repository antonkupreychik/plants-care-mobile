// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_code_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана 08 «Ввод кода из Telegram» (визуальная заглушка флоу).
///
/// Держит буфер из 6 цифр и обратный отсчёт до повторной отправки кода. Это
/// ЧИСТЫЙ UI-state: никакой верификации кода, сети, токенов или навигации — их
/// делает UI (по [AuthCodeState.isComplete] рисует активный CTA «Продолжить»).
/// autoDispose: при закрытии экрана буфер и таймер сбрасываются.
///
/// UI читает `ref.watch(authCodeControllerProvider)` ([AuthCodeState]) и зовёт:
/// [appendDigit] / [removeDigit] / [resend].
///
/// **Таймер:** один [Timer.periodic] на 1с, декремент вынесен в [_tick] (тест
/// может прогнать его через fakeAsync детерминированно). Таймер обязательно
/// освобождается в `ref.onDispose` — утечка периодического таймера это реальный
/// баг (тикал бы после ухода с экрана).

@ProviderFor(AuthCodeController)
final authCodeControllerProvider = AuthCodeControllerProvider._();

/// State-слой экрана 08 «Ввод кода из Telegram» (визуальная заглушка флоу).
///
/// Держит буфер из 6 цифр и обратный отсчёт до повторной отправки кода. Это
/// ЧИСТЫЙ UI-state: никакой верификации кода, сети, токенов или навигации — их
/// делает UI (по [AuthCodeState.isComplete] рисует активный CTA «Продолжить»).
/// autoDispose: при закрытии экрана буфер и таймер сбрасываются.
///
/// UI читает `ref.watch(authCodeControllerProvider)` ([AuthCodeState]) и зовёт:
/// [appendDigit] / [removeDigit] / [resend].
///
/// **Таймер:** один [Timer.periodic] на 1с, декремент вынесен в [_tick] (тест
/// может прогнать его через fakeAsync детерминированно). Таймер обязательно
/// освобождается в `ref.onDispose` — утечка периодического таймера это реальный
/// баг (тикал бы после ухода с экрана).
final class AuthCodeControllerProvider
    extends $NotifierProvider<AuthCodeController, AuthCodeState> {
  /// State-слой экрана 08 «Ввод кода из Telegram» (визуальная заглушка флоу).
  ///
  /// Держит буфер из 6 цифр и обратный отсчёт до повторной отправки кода. Это
  /// ЧИСТЫЙ UI-state: никакой верификации кода, сети, токенов или навигации — их
  /// делает UI (по [AuthCodeState.isComplete] рисует активный CTA «Продолжить»).
  /// autoDispose: при закрытии экрана буфер и таймер сбрасываются.
  ///
  /// UI читает `ref.watch(authCodeControllerProvider)` ([AuthCodeState]) и зовёт:
  /// [appendDigit] / [removeDigit] / [resend].
  ///
  /// **Таймер:** один [Timer.periodic] на 1с, декремент вынесен в [_tick] (тест
  /// может прогнать его через fakeAsync детерминированно). Таймер обязательно
  /// освобождается в `ref.onDispose` — утечка периодического таймера это реальный
  /// баг (тикал бы после ухода с экрана).
  AuthCodeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authCodeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authCodeControllerHash();

  @$internal
  @override
  AuthCodeController create() => AuthCodeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthCodeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthCodeState>(value),
    );
  }
}

String _$authCodeControllerHash() =>
    r'ede13f2279f9b39d3ef6bd5a6b85a0cdf97f754c';

/// State-слой экрана 08 «Ввод кода из Telegram» (визуальная заглушка флоу).
///
/// Держит буфер из 6 цифр и обратный отсчёт до повторной отправки кода. Это
/// ЧИСТЫЙ UI-state: никакой верификации кода, сети, токенов или навигации — их
/// делает UI (по [AuthCodeState.isComplete] рисует активный CTA «Продолжить»).
/// autoDispose: при закрытии экрана буфер и таймер сбрасываются.
///
/// UI читает `ref.watch(authCodeControllerProvider)` ([AuthCodeState]) и зовёт:
/// [appendDigit] / [removeDigit] / [resend].
///
/// **Таймер:** один [Timer.periodic] на 1с, декремент вынесен в [_tick] (тест
/// может прогнать его через fakeAsync детерминированно). Таймер обязательно
/// освобождается в `ref.onDispose` — утечка периодического таймера это реальный
/// баг (тикал бы после ухода с экрана).

abstract class _$AuthCodeController extends $Notifier<AuthCodeState> {
  AuthCodeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthCodeState, AuthCodeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthCodeState, AuthCodeState>,
              AuthCodeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
