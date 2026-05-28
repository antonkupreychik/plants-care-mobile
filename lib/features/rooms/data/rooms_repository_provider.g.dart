// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [RoomsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `roomsRepositoryProvider.overrideWith(...)`.

@ProviderFor(roomsRepository)
final roomsRepositoryProvider = RoomsRepositoryProvider._();

/// DI-точка для [RoomsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `roomsRepositoryProvider.overrideWith(...)`.

final class RoomsRepositoryProvider
    extends
        $FunctionalProvider<RoomsRepository, RoomsRepository, RoomsRepository>
    with $Provider<RoomsRepository> {
  /// DI-точка для [RoomsRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `roomsRepositoryProvider.overrideWith(...)`.
  RoomsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoomsRepository create(Ref ref) {
    return roomsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomsRepository>(value),
    );
  }
}

String _$roomsRepositoryHash() => r'1ef4abfb8887005b9e5e53ea48ec60170e9d0736';
