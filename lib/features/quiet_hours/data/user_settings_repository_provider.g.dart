// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [UserSettingsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через
/// `userSettingsRepositoryProvider.overrideWith(...)`.

@ProviderFor(userSettingsRepository)
final userSettingsRepositoryProvider = UserSettingsRepositoryProvider._();

/// DI-точка для [UserSettingsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через
/// `userSettingsRepositoryProvider.overrideWith(...)`.

final class UserSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          UserSettingsRepository,
          UserSettingsRepository,
          UserSettingsRepository
        >
    with $Provider<UserSettingsRepository> {
  /// DI-точка для [UserSettingsRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через
  /// `userSettingsRepositoryProvider.overrideWith(...)`.
  UserSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserSettingsRepository create(Ref ref) {
    return userSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSettingsRepository>(value),
    );
  }
}

String _$userSettingsRepositoryHash() =>
    r'6cfeb2c2a95f500c45afb5a9f6892596d35e0111';
