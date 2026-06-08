import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/archive_repository.dart';
import 'archive_repository_impl.dart';

part 'archive_repository_provider.g.dart';

/// DI-точка для [ArchiveRepository] (MADR-004: граф провайдеров = DI).
///
/// Отдаёт [ArchiveRepositoryImpl] поверх сгенерированного dio/codegen-клиента
/// (`GET /api/v1/plants?status=archived`, MADR-007, issue #149).
/// В тестах подменяется через `archiveRepositoryProvider.overrideWith(...)`.
@riverpod
ArchiveRepository archiveRepository(Ref ref) =>
    ArchiveRepositoryImpl(ref.watch(plantsCareApiProvider));
