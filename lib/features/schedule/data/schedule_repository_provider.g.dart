// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [ScheduleRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `scheduleRepositoryProvider.overrideWith(...)`.

@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider = ScheduleRepositoryProvider._();

/// DI-точка для [ScheduleRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `scheduleRepositoryProvider.overrideWith(...)`.

final class ScheduleRepositoryProvider
    extends
        $FunctionalProvider<
          ScheduleRepository,
          ScheduleRepository,
          ScheduleRepository
        >
    with $Provider<ScheduleRepository> {
  /// DI-точка для [ScheduleRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `scheduleRepositoryProvider.overrideWith(...)`.
  ScheduleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScheduleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScheduleRepository create(Ref ref) {
    return scheduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleRepository>(value),
    );
  }
}

String _$scheduleRepositoryHash() =>
    r'b153df43d48d2c28cb6d5409cd399ed6fe186161';
