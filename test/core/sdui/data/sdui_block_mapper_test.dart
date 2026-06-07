import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/action_descriptor.dart';
import 'package:plantcare_mobile/core/api/generated/models/action_descriptor_kind.dart';
import 'package:plantcare_mobile/core/api/generated/models/block.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_chip.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_chips_block_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_grid_block_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_grid_item.dart';
import 'package:plantcare_mobile/core/api/generated/models/today_summary_block_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/weather_strip_block_recommendation.dart';
import 'package:plantcare_mobile/core/api/generated/models/weather_strip_block_type.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_block_mapper.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_action.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';

void main() {
  group('BlockDtoMapper.toDomain', () {
    test('weather_strip maps available + humidity + recommendation', () {
      const dto = BlockWeatherStripBlock(
        type: WeatherStripBlockType.weatherStrip,
        available: true,
        humidityPercent: 55,
        recommendation: WeatherStripBlockRecommendation.deferOk,
        fetchedAt: null,
        fromCache: null,
      );

      final block = dto.toDomain();

      expect(
        block,
        const SduiBlock.weatherStrip(
          available: true,
          humidityPercent: 55,
          recommendation: WateringRecommendation.deferOk,
        ),
      );
    });

    test('weather_strip clamps out-of-range humidity and maps unavailable', () {
      const dto = BlockWeatherStripBlock(
        type: WeatherStripBlockType.weatherStrip,
        available: false,
        humidityPercent: 250,
        recommendation: WeatherStripBlockRecommendation.$unknown,
        fetchedAt: null,
        fromCache: null,
      );

      final block = dto.toDomain() as SduiWeatherStripBlock;

      expect(block.available, isFalse);
      expect(block.humidityPercent, 100);
      // $unknown рекомендация деградирует в neutral, не падает.
      expect(block.recommendation, WateringRecommendation.neutral);
    });

    test('today_summary maps counters', () {
      const dto = BlockTodaySummaryBlock(
        type: TodaySummaryBlockType.todaySummary,
        total: 5,
        done: 2,
        remaining: 3,
        overdue: 1,
      );

      expect(
        dto.toDomain(),
        const SduiBlock.todaySummary(
          total: 5,
          done: 2,
          remaining: 3,
          overdue: 1,
        ),
      );
    });

    test('location_chips maps each chip to GardenLocation', () {
      const dto = BlockLocationChipsBlock(
        type: LocationChipsBlockType.locationChips,
        locations: [
          LocationChip(id: 1, name: 'Кухня', emoji: '🍳'),
          LocationChip(id: 2, name: 'Спальня'),
        ],
      );

      final block = dto.toDomain() as SduiLocationChipsBlock;

      expect(block.locations, hasLength(2));
      expect(block.locations.first.id, 1);
      expect(block.locations.first.name, 'Кухня');
      expect(block.locations.first.emoji, '🍳');
      expect(block.locations[1].emoji, isNull);
    });

    test('plant_grid maps items with log_care action', () {
      const dto = BlockPlantGridBlock(
        type: PlantGridBlockType.plantGrid,
        plants: [
          PlantGridItem(
            id: 7,
            name: 'Монстера',
            locationName: 'Кухня',
            action: ActionDescriptor(
              kind: ActionDescriptorKind.logCare,
              method: 'POST',
              path: '/care-events',
              payloadTemplate: {'plantId': 7, 'type': 'WATER'},
            ),
          ),
          PlantGridItem(id: 8, name: 'Кактус'),
        ],
      );

      final block = dto.toDomain() as SduiPlantGridBlock;

      expect(block.plants, hasLength(2));
      final first = block.plants.first;
      expect(first.id, 7);
      expect(first.name, 'Монстера');
      expect(first.locationName, 'Кухня');
      expect(first.action, isNotNull);
      expect(first.action!.kind, SduiActionKind.logCare);
      expect(first.action!.payload, {'plantId': 7, 'type': 'WATER'});
      // Второй элемент без действия.
      expect(block.plants[1].action, isNull);
    });

    test(r'plant_grid action with $unknown kind degrades to unknown', () {
      const dto = BlockPlantGridBlock(
        type: PlantGridBlockType.plantGrid,
        plants: [
          PlantGridItem(
            id: 1,
            name: 'X',
            action: ActionDescriptor(
              kind: ActionDescriptorKind.$unknown,
              method: 'POST',
              path: '/whatever',
            ),
          ),
        ],
      );

      final block = dto.toDomain() as SduiPlantGridBlock;
      expect(block.plants.first.action!.kind, SduiActionKind.unknown);
    });
  });
}
