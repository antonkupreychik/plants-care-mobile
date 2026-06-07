// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'take_cutting_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [TakeCuttingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `takeCuttingRepositoryProvider.overrideWith(...)`.

@ProviderFor(takeCuttingRepository)
final takeCuttingRepositoryProvider = TakeCuttingRepositoryProvider._();

/// DI-точка для [TakeCuttingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `takeCuttingRepositoryProvider.overrideWith(...)`.

final class TakeCuttingRepositoryProvider
    extends
        $FunctionalProvider<
          TakeCuttingRepository,
          TakeCuttingRepository,
          TakeCuttingRepository
        >
    with $Provider<TakeCuttingRepository> {
  /// DI-точка для [TakeCuttingRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `takeCuttingRepositoryProvider.overrideWith(...)`.
  TakeCuttingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'takeCuttingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$takeCuttingRepositoryHash();

  @$internal
  @override
  $ProviderElement<TakeCuttingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TakeCuttingRepository create(Ref ref) {
    return takeCuttingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TakeCuttingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TakeCuttingRepository>(value),
    );
  }
}

String _$takeCuttingRepositoryHash() =>
    r'66e83d9a43957b51e03d51b7daec343bf1fadf23';
