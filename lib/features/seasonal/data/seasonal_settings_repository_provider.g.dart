// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_settings_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [SeasonalSettingsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через
/// `seasonalSettingsRepositoryProvider.overrideWith(...)`.

@ProviderFor(seasonalSettingsRepository)
final seasonalSettingsRepositoryProvider =
    SeasonalSettingsRepositoryProvider._();

/// DI-точка для [SeasonalSettingsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через
/// `seasonalSettingsRepositoryProvider.overrideWith(...)`.

final class SeasonalSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SeasonalSettingsRepository,
          SeasonalSettingsRepository,
          SeasonalSettingsRepository
        >
    with $Provider<SeasonalSettingsRepository> {
  /// DI-точка для [SeasonalSettingsRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через
  /// `seasonalSettingsRepositoryProvider.overrideWith(...)`.
  SeasonalSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalSettingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SeasonalSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SeasonalSettingsRepository create(Ref ref) {
    return seasonalSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeasonalSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeasonalSettingsRepository>(value),
    );
  }
}

String _$seasonalSettingsRepositoryHash() =>
    r'0e74804bfd514e7eebb9e74ffaf95718367736f9';
