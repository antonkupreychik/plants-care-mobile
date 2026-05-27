// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_event_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [CareEventRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `careEventRepositoryProvider.overrideWith(...)`.

@ProviderFor(careEventRepository)
final careEventRepositoryProvider = CareEventRepositoryProvider._();

/// DI-точка для [CareEventRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `careEventRepositoryProvider.overrideWith(...)`.

final class CareEventRepositoryProvider
    extends
        $FunctionalProvider<
          CareEventRepository,
          CareEventRepository,
          CareEventRepository
        >
    with $Provider<CareEventRepository> {
  /// DI-точка для [CareEventRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `careEventRepositoryProvider.overrideWith(...)`.
  CareEventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careEventRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careEventRepositoryHash();

  @$internal
  @override
  $ProviderElement<CareEventRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CareEventRepository create(Ref ref) {
    return careEventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareEventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareEventRepository>(value),
    );
  }
}

String _$careEventRepositoryHash() =>
    r'68a3d4f2554e86e186ef3206d3628c7c4020a192';
