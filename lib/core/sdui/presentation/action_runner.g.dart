// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_runner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка [ActionRunner] (MADR-004: граф провайдеров = DI). Виджеты берут его
/// через `ref.read(actionRunnerProvider)` в колбэке действия.

@ProviderFor(actionRunner)
final actionRunnerProvider = ActionRunnerProvider._();

/// DI-точка [ActionRunner] (MADR-004: граф провайдеров = DI). Виджеты берут его
/// через `ref.read(actionRunnerProvider)` в колбэке действия.

final class ActionRunnerProvider
    extends $FunctionalProvider<ActionRunner, ActionRunner, ActionRunner>
    with $Provider<ActionRunner> {
  /// DI-точка [ActionRunner] (MADR-004: граф провайдеров = DI). Виджеты берут его
  /// через `ref.read(actionRunnerProvider)` в колбэке действия.
  ActionRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionRunnerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionRunnerHash();

  @$internal
  @override
  $ProviderElement<ActionRunner> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActionRunner create(Ref ref) {
    return actionRunner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionRunner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionRunner>(value),
    );
  }
}

String _$actionRunnerHash() => r'fe350e4ed358b1bbdeaa2690c9b367483c0ce397';
