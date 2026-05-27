import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/add_plant_repository.dart';
import 'add_plant_repository_impl.dart';

part 'add_plant_repository_provider.g.dart';

/// DI-точка для [AddPlantRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `addPlantRepositoryProvider.overrideWith(...)`.
@riverpod
AddPlantRepository addPlantRepository(Ref ref) =>
    AddPlantRepositoryImpl(ref.watch(plantsCareApiProvider));
