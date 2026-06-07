import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/plant_family_repository_provider.dart';
import '../domain/plant_family.dart';

part 'plant_family_providers.g.dart';

/// State-слой экрана «Родословная / размножение» (18).
///
/// Контракт для ui-builder:
/// - [plantFamilyProvider] — `AsyncValue<PlantFamily>` (loading / error / data).
///   В `AsyncError` лежит типизированный [ApiError]. Из `data` UI читает
///   `family.parent` (или `null`), `family.children`, `family.hasRelations`.
///   Retry — `ref.invalidate(plantFamilyProvider(plantId))`.
///
/// Один family-провайдер по `plantId` (не агрегат — экран читает ровно одну
/// ручку). При навигации в карточку другого члена семьи и обратно состояние
/// перечитывается автоматически (autoDispose).
@riverpod
Future<PlantFamily> plantFamily(Ref ref, int plantId) async {
  final result = await ref.watch(plantFamilyRepositoryProvider).getFamily(plantId);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
