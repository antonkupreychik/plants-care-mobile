// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [HomeRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `homeRepositoryProvider.overrideWith(...)`.

@ProviderFor(homeRepository)
final homeRepositoryProvider = HomeRepositoryProvider._();

/// DI-точка для [HomeRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `homeRepositoryProvider.overrideWith(...)`.

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  /// DI-точка для [HomeRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `homeRepositoryProvider.overrideWith(...)`.
  HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'cee6e9d3b36279bf099c8cd84872a25db3b74c4c';
