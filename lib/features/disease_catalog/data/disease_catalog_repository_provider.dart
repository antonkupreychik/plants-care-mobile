import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/disease_repository.dart';
import 'disease_catalog_repository_impl.dart';

part 'disease_catalog_repository_provider.g.dart';

/// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
///
/// Использует реальную реализацию [DiseaseCatalogRepositoryImpl] поверх
/// `DiseasesClient` (issue #150). В тестах подменяется через
/// `diseaseCatalogRepositoryProvider.overrideWith(...)`.
@riverpod
DiseaseCatalogRepository diseaseCatalogRepository(Ref ref) =>
    DiseaseCatalogRepositoryImpl(ref.watch(plantsCareApiProvider));
