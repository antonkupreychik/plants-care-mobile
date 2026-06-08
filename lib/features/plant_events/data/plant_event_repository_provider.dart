import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/plant_event_repository.dart';
import 'plant_event_repository_impl.dart';

part 'plant_event_repository_provider.g.dart';

/// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
///
/// Отдаёт [PlantEventRepositoryImpl] поверх сгенерированного `PlantEventsClient`
/// (`GET/POST /plants/{id}/events`, backend #220), как `careEventRepository`.
/// В тестах подменяется через `plantEventRepositoryProvider.overrideWith(...)`.
@riverpod
PlantEventRepository plantEventRepository(Ref ref) =>
    PlantEventRepositoryImpl(ref.watch(plantsCareApiProvider).plantEvents);
