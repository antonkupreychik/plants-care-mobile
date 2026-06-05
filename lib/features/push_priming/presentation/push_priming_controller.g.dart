// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_priming_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifier решения пользователя по праймингу пушей (экран 27).
///
/// Codegen (Riverpod 3) генерирует переменную **`pushPrimingControllerProvider`**.
///
/// Контракт для UI:
/// - `ref.watch(pushPrimingControllerProvider)` → `AsyncValue<PushPrimingDecision>`
/// - `ref.read(pushPrimingControllerProvider.notifier).allow()`
/// - `ref.read(pushPrimingControllerProvider.notifier).postpone()`
///
/// Реальный системный запрос разрешений и регистрация push-токена
/// (`POST /api/v1/devices`) здесь НЕ выполняются: они появятся отдельной
/// задачей после решения по push-стеку (README §9 #3) и эндпоинта backend #187.
/// Сейчас фиксируется только намерение пользователя (локальный персист).

@ProviderFor(PushPrimingController)
final pushPrimingControllerProvider = PushPrimingControllerProvider._();

/// AsyncNotifier решения пользователя по праймингу пушей (экран 27).
///
/// Codegen (Riverpod 3) генерирует переменную **`pushPrimingControllerProvider`**.
///
/// Контракт для UI:
/// - `ref.watch(pushPrimingControllerProvider)` → `AsyncValue<PushPrimingDecision>`
/// - `ref.read(pushPrimingControllerProvider.notifier).allow()`
/// - `ref.read(pushPrimingControllerProvider.notifier).postpone()`
///
/// Реальный системный запрос разрешений и регистрация push-токена
/// (`POST /api/v1/devices`) здесь НЕ выполняются: они появятся отдельной
/// задачей после решения по push-стеку (README §9 #3) и эндпоинта backend #187.
/// Сейчас фиксируется только намерение пользователя (локальный персист).
final class PushPrimingControllerProvider
    extends $AsyncNotifierProvider<PushPrimingController, PushPrimingDecision> {
  /// AsyncNotifier решения пользователя по праймингу пушей (экран 27).
  ///
  /// Codegen (Riverpod 3) генерирует переменную **`pushPrimingControllerProvider`**.
  ///
  /// Контракт для UI:
  /// - `ref.watch(pushPrimingControllerProvider)` → `AsyncValue<PushPrimingDecision>`
  /// - `ref.read(pushPrimingControllerProvider.notifier).allow()`
  /// - `ref.read(pushPrimingControllerProvider.notifier).postpone()`
  ///
  /// Реальный системный запрос разрешений и регистрация push-токена
  /// (`POST /api/v1/devices`) здесь НЕ выполняются: они появятся отдельной
  /// задачей после решения по push-стеку (README §9 #3) и эндпоинта backend #187.
  /// Сейчас фиксируется только намерение пользователя (локальный персист).
  PushPrimingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushPrimingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushPrimingControllerHash();

  @$internal
  @override
  PushPrimingController create() => PushPrimingController();
}

String _$pushPrimingControllerHash() =>
    r'f7730bf083260cddac32e55a9e980890ef92e959';

/// AsyncNotifier решения пользователя по праймингу пушей (экран 27).
///
/// Codegen (Riverpod 3) генерирует переменную **`pushPrimingControllerProvider`**.
///
/// Контракт для UI:
/// - `ref.watch(pushPrimingControllerProvider)` → `AsyncValue<PushPrimingDecision>`
/// - `ref.read(pushPrimingControllerProvider.notifier).allow()`
/// - `ref.read(pushPrimingControllerProvider.notifier).postpone()`
///
/// Реальный системный запрос разрешений и регистрация push-токена
/// (`POST /api/v1/devices`) здесь НЕ выполняются: они появятся отдельной
/// задачей после решения по push-стеку (README §9 #3) и эндпоинта backend #187.
/// Сейчас фиксируется только намерение пользователя (локальный персист).

abstract class _$PushPrimingController
    extends $AsyncNotifier<PushPrimingDecision> {
  FutureOr<PushPrimingDecision> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PushPrimingDecision>, PushPrimingDecision>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PushPrimingDecision>, PushPrimingDecision>,
              AsyncValue<PushPrimingDecision>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
