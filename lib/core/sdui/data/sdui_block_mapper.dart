import '../../../core/api/generated/models/action_descriptor.dart';
import '../../../core/api/generated/models/action_descriptor_kind.dart';
import '../../../core/api/generated/models/block.dart';
import '../../../core/api/generated/models/location_chip.dart';
import '../../../core/api/generated/models/plant_grid_item.dart';
import '../../../core/api/generated/models/weather_strip_block_recommendation.dart';
import '../../locations/garden_location.dart';
import '../../../features/weather/domain/watering_recommendation.dart';
import '../domain/sdui_action.dart';
import '../domain/sdui_block.dart';

/// Маппинг сгенерированных SDUI-DTO (`Block` и наследники) → domain [SduiBlock]
/// (MADR-002/007). Делаем руками — сгенерированный код не правим.
///
/// Сгенерированный `Block.fromJson` бросает `FormatException` на неизвестном
/// дискриминаторе ещё ДО этого маппера, поэтому пропуск неизвестного типа на
/// контракте делает репозиторий (per-block try/catch). Сам `Block` — sealed из
/// ровно 4 известных подтипов, поэтому switch ниже исчерпывающий; домен-вариант
/// [SduiUnknownBlock] здесь не возникает (его источник — пропуск в репозитории).
extension BlockDtoMapper on Block {
  SduiBlock toDomain() => switch (this) {
        final BlockWeatherStripBlock b => SduiBlock.weatherStrip(
            available: b.available,
            // Клампим 0..100 — кодген границы не валидирует.
            humidityPercent: b.humidityPercent?.clamp(0, 100),
            recommendation: b.recommendation?._toDomain(),
          ),
        final BlockTodaySummaryBlock b => SduiBlock.todaySummary(
            total: b.total,
            done: b.done,
            remaining: b.remaining,
            overdue: b.overdue,
          ),
        final BlockLocationChipsBlock b => SduiBlock.locationChips(
            locations:
                b.locations.map((c) => c._toDomain()).toList(growable: false),
          ),
        final BlockPlantGridBlock b => SduiBlock.plantGrid(
            plants:
                b.plants.map((p) => p._toDomain()).toList(growable: false),
          ),
      };
}

/// `WeatherStripBlockRecommendation` (вкл. `$unknown`) → доменная
/// [WateringRecommendation]. `$unknown` (новая рекомендация на backend) мягко
/// деградирует в `neutral` — экран не падает.
extension on WeatherStripBlockRecommendation {
  WateringRecommendation _toDomain() => switch (this) {
        WeatherStripBlockRecommendation.deferOk =>
          WateringRecommendation.deferOk,
        WeatherStripBlockRecommendation.doNotDefer =>
          WateringRecommendation.doNotDefer,
        WeatherStripBlockRecommendation.neutral =>
          WateringRecommendation.neutral,
        WeatherStripBlockRecommendation.$unknown =>
          WateringRecommendation.neutral,
      };
}

/// `LocationChip` → доменная [GardenLocation]. SDUI-чип не несёт `isDefault`
/// (для рендера чипа он не нужен) — ставим `false`.
extension on LocationChip {
  GardenLocation _toDomain() => GardenLocation(
        id: id,
        name: name,
        emoji: emoji,
        isDefault: false,
      );
}

/// `PlantGridItem` → доменный [SduiPlantGridItem] (+ опциональное действие).
extension on PlantGridItem {
  SduiPlantGridItem _toDomain() => SduiPlantGridItem(
        id: id,
        name: name,
        locationName: locationName,
        action: action?._toDomain(),
      );
}

/// `ActionDescriptor` → доменный [SduiAction]. `kind` нормализуем через
/// [SduiActionKind.fromApi]: нераспознанный/`$unknown` → [SduiActionKind.unknown]
/// (`ActionRunner` такое действие не исполняет, но и не падает).
extension on ActionDescriptor {
  SduiAction _toDomain() => SduiAction(
        kind: SduiActionKind.fromApi(_kindJson(kind)),
        method: method,
        path: path,
        payload: payloadTemplate is Map
            ? Map<String, dynamic>.from(payloadTemplate as Map)
            : null,
      );
}

/// Достаёт строковое представление `kind` из сгенерированного enum, не бросая
/// на `$unknown` (его `toJson` кидает StateError).
String? _kindJson(ActionDescriptorKind kind) =>
    kind == ActionDescriptorKind.$unknown ? null : kind.json;
