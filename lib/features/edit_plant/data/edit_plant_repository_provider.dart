import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/edit_plant_repository.dart';
import 'edit_plant_repository_impl.dart';

part 'edit_plant_repository_provider.g.dart';

/// DI-точка для [EditPlantRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `editPlantRepositoryProvider.overrideWith(...)`.
@riverpod
EditPlantRepository editPlantRepository(Ref ref) =>
    EditPlantRepositoryImpl(ref.watch(plantsCareApiProvider));
