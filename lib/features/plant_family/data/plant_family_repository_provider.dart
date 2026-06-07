import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/plant_family_repository.dart';
import 'plant_family_repository_impl.dart';

part 'plant_family_repository_provider.g.dart';

/// DI-точка для [PlantFamilyRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantFamilyRepositoryProvider.overrideWith(...)`.
@riverpod
PlantFamilyRepository plantFamilyRepository(Ref ref) =>
    PlantFamilyRepositoryImpl(ref.watch(plantsCareApiProvider));
