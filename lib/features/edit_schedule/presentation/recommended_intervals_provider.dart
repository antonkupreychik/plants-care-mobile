import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/care/care_task_type.dart';
import '../../catalog/presentation/catalog_providers.dart';
import '../../plant_card/presentation/plant_card_providers.dart';

part 'recommended_intervals_provider.g.dart';

/// Рекомендованные интервалы ухода (в днях) для вида растения — основа кнопки
/// «Сбросить» на экране 22.
///
/// Family по [plantId]. Источник:
/// 1. деталь растения (`plantDetailProvider`) → `speciesId`;
/// 2. деталь вида (`speciesDetailProvider`) → `wateringDays` / `mistingDays` /
///    `fertilizingDays` / `soilCheckDays`.
///
/// Переиспользует существующие family-провайдеры (общий кэш, без дублирующих
/// запросов).
///
/// Контракт для ui-builder: `AsyncValue<Map<CareTaskType, int>?>`.
/// - `null` (data) → у растения нет `speciesId`, вид не загрузился, или у вида
///   нет ни одного интервала → UI скрывает «Сбросить»;
/// - непустой `Map` → доступные рекомендации (только те *Days, что не `null`),
///   передаётся в `EditScheduleController.reset(...)`.
///
/// Ошибку загрузки растения/вида НЕ пробрасываем как `AsyncError`: «Сбросить» —
/// необязательная функция, её отсутствие не должно ломать экран. Любая неудача
/// или отсутствие данных → `null`.
@riverpod
Future<Map<CareTaskType, int>?> recommendedIntervals(
  Ref ref,
  int plantId,
) async {
  final int? speciesId;
  try {
    final plant = await ref.watch(plantDetailProvider(plantId).future);
    speciesId = plant.speciesId;
  } catch (_) {
    // Растение не загрузилось — рекомендации недоступны, не валим экран.
    return null;
  }
  if (speciesId == null) return null;

  try {
    final species = await ref.watch(speciesDetailProvider(speciesId).future);
    final map = <CareTaskType, int>{};
    if (species.wateringDays != null) {
      map[CareTaskType.watering] = species.wateringDays!;
    }
    if (species.mistingDays != null) {
      map[CareTaskType.misting] = species.mistingDays!;
    }
    if (species.fertilizingDays != null) {
      map[CareTaskType.fertilizing] = species.fertilizingDays!;
    }
    if (species.soilCheckDays != null) {
      map[CareTaskType.soilCheck] = species.soilCheckDays!;
    }
    return map.isEmpty ? null : map;
  } catch (_) {
    // Вид не загрузился — «Сбросить» скрываем.
    return null;
  }
}
