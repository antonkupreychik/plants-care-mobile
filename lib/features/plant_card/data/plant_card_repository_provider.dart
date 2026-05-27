import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/plant_card_repository.dart';
import 'plant_card_repository_impl.dart';

part 'plant_card_repository_provider.g.dart';

/// DI-точка для [PlantCardRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `plantCardRepositoryProvider.overrideWith(...)`.
@riverpod
PlantCardRepository plantCardRepository(Ref ref) =>
    PlantCardRepositoryImpl(ref.watch(plantsCareApiProvider));
