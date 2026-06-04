import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/disease_repository.dart';
import 'fake_disease_catalog_repository_impl.dart';

part 'disease_catalog_repository_provider.g.dart';

/// DI-точка для [DiseaseCatalogRepository] (MADR-004: граф провайдеров = DI).
///
/// Пока backend-эндпоинты не готовы (`plants-care#225`) — отдаёт
/// [FakeDiseaseCatalogRepositoryImpl]. После регена OpenAPI-клиента здесь
/// меняется только реализация (`DiseaseCatalogRepositoryImpl`), контракт
/// провайдера и presentation не трогаются. В тестах подменяется через
/// `diseaseCatalogRepositoryProvider.overrideWith(...)`.
@riverpod
DiseaseCatalogRepository diseaseCatalogRepository(Ref ref) =>
    const FakeDiseaseCatalogRepositoryImpl();
