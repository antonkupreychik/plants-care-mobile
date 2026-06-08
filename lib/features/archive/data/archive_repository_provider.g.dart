// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
///
/// Отдаёт [ArchiveRepositoryImpl] поверх сгенерированного dio/codegen-клиента
/// (`GET /api/v1/plants?status=archived`, MADR-007, issue #149).
/// В тестах подменяется через `archiveRepositoryProvider.overrideWith(...)`.

@ProviderFor(archiveRepository)
final archiveRepositoryProvider = ArchiveRepositoryProvider._();

/// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
///
/// Отдаёт [ArchiveRepositoryImpl] поверх сгенерированного dio/codegen-клиента
/// (`GET /api/v1/plants?status=archived`, MADR-007, issue #149).
/// В тестах подменяется через `archiveRepositoryProvider.overrideWith(...)`.

final class ArchiveRepositoryProvider
    extends
        $FunctionalProvider<
          ArchiveRepository,
          ArchiveRepository,
          ArchiveRepository
        >
    with $Provider<ArchiveRepository> {
  /// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// Отдаёт [ArchiveRepositoryImpl] поверх сгенерированного dio/codegen-клиента
  /// (`GET /api/v1/plants?status=archived`, MADR-007, issue #149).
  /// В тестах подменяется через `archiveRepositoryProvider.overrideWith(...)`.
  ArchiveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveRepositoryHash();

  @$internal
  @override
  $ProviderElement<ArchiveRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ArchiveRepository create(Ref ref) {
    return archiveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArchiveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArchiveRepository>(value),
    );
  }
}

String _$archiveRepositoryHash() => r'2bc28a965250aaf28bc7932cd326a682cf193b46';
