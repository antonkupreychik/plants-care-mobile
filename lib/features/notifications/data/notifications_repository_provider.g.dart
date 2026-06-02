// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [NotificationsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `notificationsRepositoryProvider.overrideWith(...)`.

@ProviderFor(notificationsRepository)
final notificationsRepositoryProvider = NotificationsRepositoryProvider._();

/// DI-точка для [NotificationsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `notificationsRepositoryProvider.overrideWith(...)`.

final class NotificationsRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationsRepository,
          NotificationsRepository,
          NotificationsRepository
        >
    with $Provider<NotificationsRepository> {
  /// DI-точка для [NotificationsRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `notificationsRepositoryProvider.overrideWith(...)`.
  NotificationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationsRepository create(Ref ref) {
    return notificationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsRepository>(value),
    );
  }
}

String _$notificationsRepositoryHash() =>
    r'143fc1380af972296777eab4bf8bae6947238cb5';
