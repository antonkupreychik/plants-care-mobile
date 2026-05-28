import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive_repository.dart';
import 'fake_archive_repository_impl.dart';

part 'archive_repository_provider.g.dart';

/// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
///
/// Сейчас отдаёт [FakeArchiveRepositoryImpl] (статичный мок, BACKEND-GAPS #117).
/// Когда backend отдаст эндпоинт архива — здесь подставится реальная
/// dio/codegen-реализация (`ref.watch(plantsCareApiProvider)`), как в
/// `roomsRepositoryProvider`. В тестах подменяется через
/// `archiveRepositoryProvider.overrideWith(...)`.
@riverpod
ArchiveRepository archiveRepository(Ref ref) =>
    const FakeArchiveRepositoryImpl();
