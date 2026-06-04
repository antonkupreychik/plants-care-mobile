// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_history_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [CareHistoryRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `careHistoryRepositoryProvider.overrideWith(...)`.

@ProviderFor(careHistoryRepository)
final careHistoryRepositoryProvider = CareHistoryRepositoryProvider._();

/// DI-точка для [CareHistoryRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `careHistoryRepositoryProvider.overrideWith(...)`.

final class CareHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          CareHistoryRepository,
          CareHistoryRepository,
          CareHistoryRepository
        >
    with $Provider<CareHistoryRepository> {
  /// DI-точка для [CareHistoryRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `careHistoryRepositoryProvider.overrideWith(...)`.
  CareHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careHistoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CareHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CareHistoryRepository create(Ref ref) {
    return careHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareHistoryRepository>(value),
    );
  }
}

String _$careHistoryRepositoryHash() =>
    r'75002a6388b6b6d82fc517204b2682f9933f9ad8';
