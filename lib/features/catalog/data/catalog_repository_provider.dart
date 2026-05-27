import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/catalog_repository.dart';
import 'catalog_repository_impl.dart';

part 'catalog_repository_provider.g.dart';

/// DI-точка для [CatalogRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `catalogRepositoryProvider.overrideWith(...)`.
@riverpod
CatalogRepository catalogRepository(Ref ref) =>
    CatalogRepositoryImpl(ref.watch(plantsCareApiProvider));
