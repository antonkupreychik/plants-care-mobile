// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
///
/// Сейчас отдаёт [FakeArchiveRepositoryImpl] (статичный мок, BACKEND-GAPS #117).
/// Когда backend отдаст эндпоинт архива — здесь подставится реальная
/// dio/codegen-реализация (`ref.watch(plantsCareApiProvider)`), как в
/// `roomsRepositoryProvider`. В тестах подменяется через
/// `archiveRepositoryProvider.overrideWith(...)`.

@ProviderFor(archiveRepository)
final archiveRepositoryProvider = ArchiveRepositoryProvider._();

/// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
///
/// Сейчас отдаёт [FakeArchiveRepositoryImpl] (статичный мок, BACKEND-GAPS #117).
/// Когда backend отдаст эндпоинт архива — здесь подставится реальная
/// dio/codegen-реализация (`ref.watch(plantsCareApiProvider)`), как в
/// `roomsRepositoryProvider`. В тестах подменяется через
/// `archiveRepositoryProvider.overrideWith(...)`.

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
  /// Сейчас отдаёт [FakeArchiveRepositoryImpl] (статичный мок, BACKEND-GAPS #117).
  /// Когда backend отдаст эндпоинт архива — здесь подставится реальная
  /// dio/codegen-реализация (`ref.watch(plantsCareApiProvider)`), как в
  /// `roomsRepositoryProvider`. В тестах подменяется через
  /// `archiveRepositoryProvider.overrideWith(...)`.
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

String _$archiveRepositoryHash() => r'1bf49910f3cb339805aa8010e3b0266b4787dd51';
