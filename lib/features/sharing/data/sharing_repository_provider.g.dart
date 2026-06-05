// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [SharingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `sharingRepositoryProvider.overrideWith(...)`.

@ProviderFor(sharingRepository)
final sharingRepositoryProvider = SharingRepositoryProvider._();

/// DI-точка для [SharingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `sharingRepositoryProvider.overrideWith(...)`.

final class SharingRepositoryProvider
    extends
        $FunctionalProvider<
          SharingRepository,
          SharingRepository,
          SharingRepository
        >
    with $Provider<SharingRepository> {
  /// DI-точка для [SharingRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `sharingRepositoryProvider.overrideWith(...)`.
  SharingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharingRepositoryHash();

  @$internal
  @override
  $ProviderElement<SharingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharingRepository create(Ref ref) {
    return sharingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharingRepository>(value),
    );
  }
}

String _$sharingRepositoryHash() => r'0c4556cc31883952f4362715c35edf1d9859fa45';
