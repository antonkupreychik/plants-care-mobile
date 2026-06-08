import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/plant_template_repository.dart';
import 'plant_template_repository_impl.dart';

part 'plant_template_repository_provider.g.dart';

/// DI-точка для [PlantTemplateRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantTemplateRepositoryProvider.overrideWith(...)`.
@riverpod
PlantTemplateRepository plantTemplateRepository(Ref ref) =>
    PlantTemplateRepositoryImpl(ref.watch(plantsCareApiProvider));
