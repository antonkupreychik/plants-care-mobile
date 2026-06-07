// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Состояние процесса удаления аккаунта.
///
/// Первоначальный false — ничего не происходит; во время вызова — loading;
/// по завершению — success или error (через AsyncError).

@ProviderFor(DeleteAccountNotifier)
final deleteAccountProvider = DeleteAccountNotifierProvider._();

/// Состояние процесса удаления аккаунта.
///
/// Первоначальный false — ничего не происходит; во время вызова — loading;
/// по завершению — success или error (через AsyncError).
final class DeleteAccountNotifierProvider
    extends $NotifierProvider<DeleteAccountNotifier, AsyncValue<void>> {
  /// Состояние процесса удаления аккаунта.
  ///
  /// Первоначальный false — ничего не происходит; во время вызова — loading;
  /// по завершению — success или error (через AsyncError).
  DeleteAccountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountNotifierHash();

  @$internal
  @override
  DeleteAccountNotifier create() => DeleteAccountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$deleteAccountNotifierHash() =>
    r'd504c7f078ea8d63c499709ebe3839dc07e9778c';

/// Состояние процесса удаления аккаунта.
///
/// Первоначальный false — ничего не происходит; во время вызова — loading;
/// по завершению — success или error (через AsyncError).

abstract class _$DeleteAccountNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
