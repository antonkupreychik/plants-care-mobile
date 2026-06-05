// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_priming_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [PushPrimingRepository] (MADR-004: граф провайдеров = DI).
///
/// Создаёт [PushPrimingRepositoryImpl] с [FlutterSecureStorage].
/// В тестах подменяется через `pushPrimingRepositoryProvider.overrideWith(...)`.

@ProviderFor(pushPrimingRepository)
final pushPrimingRepositoryProvider = PushPrimingRepositoryProvider._();

/// DI-точка для [PushPrimingRepository] (MADR-004: граф провайдеров = DI).
///
/// Создаёт [PushPrimingRepositoryImpl] с [FlutterSecureStorage].
/// В тестах подменяется через `pushPrimingRepositoryProvider.overrideWith(...)`.

final class PushPrimingRepositoryProvider
    extends
        $FunctionalProvider<
          PushPrimingRepository,
          PushPrimingRepository,
          PushPrimingRepository
        >
    with $Provider<PushPrimingRepository> {
  /// DI-точка для [PushPrimingRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// Создаёт [PushPrimingRepositoryImpl] с [FlutterSecureStorage].
  /// В тестах подменяется через `pushPrimingRepositoryProvider.overrideWith(...)`.
  PushPrimingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushPrimingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushPrimingRepositoryHash();

  @$internal
  @override
  $ProviderElement<PushPrimingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushPrimingRepository create(Ref ref) {
    return pushPrimingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushPrimingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushPrimingRepository>(value),
    );
  }
}

String _$pushPrimingRepositoryHash() =>
    r'91b10ed8b349b3105d5286543392de4b6ef10173';
