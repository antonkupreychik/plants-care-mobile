import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/dio_provider.dart';
import 'generated/plants_care_api.dart';

part 'api_provider.g.dart';

/// Сгенерированный API-клиент (MADR-007) поверх общего [Dio] с интерсепторами
/// (auth-scope, маппинг ошибок, ретраи — MADR-006). Репозитории фич берут
/// нужный под-клиент: `ref.watch(plantsCareApiProvider).plants.listPlants(...)`.
@riverpod
PlantsCareApi plantsCareApi(Ref ref) => PlantsCareApi(ref.watch(dioProvider));
