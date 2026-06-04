// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [ReportsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `reportsRepositoryProvider.overrideWith(...)`.

@ProviderFor(reportsRepository)
final reportsRepositoryProvider = ReportsRepositoryProvider._();

/// DI-точка для [ReportsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `reportsRepositoryProvider.overrideWith(...)`.

final class ReportsRepositoryProvider
    extends
        $FunctionalProvider<
          ReportsRepository,
          ReportsRepository,
          ReportsRepository
        >
    with $Provider<ReportsRepository> {
  /// DI-точка для [ReportsRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `reportsRepositoryProvider.overrideWith(...)`.
  ReportsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportsRepository create(Ref ref) {
    return reportsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportsRepository>(value),
    );
  }
}

String _$reportsRepositoryHash() => r'c865c732d1fc9d343171414d434ac7d41c15539f';
