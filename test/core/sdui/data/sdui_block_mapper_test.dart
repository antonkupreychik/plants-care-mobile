import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_block_mapper.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_action.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';

void main() {
  group('sduiBlockFromJson (opaque Map → domain)', () {
    test('weather_strip maps available + humidity + recommendation', () {
      final block = sduiBlockFromJson({
        'type': 'weather_strip',
        'available': true,
        'humidityPercent': 55,
        'recommendation': 'DEFER_OK',
        'fetchedAt': '2026-05-28T12:00:00Z',
        'fromCache': false,
      });

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
      final block = sduiBlockFromJson({
        'type': 'weather_strip',
        'available': false,
        'humidityPercent': 250,
        // Неизвестная рекомендация деградирует в neutral, не падает.
        'recommendation': 'SOMETHING_NEW',
      }) as SduiWeatherStripBlock;

      expect(block.available, isFalse);
      expect(block.humidityPercent, 100);
      expect(block.recommendation, WateringRecommendation.neutral);
    });

    test('weather_strip missing optional fields → null humidity/recommendation',
        () {
      final block = sduiBlockFromJson({
        'type': 'weather_strip',
        'available': false,
      }) as SduiWeatherStripBlock;

      expect(block.available, isFalse);
      expect(block.humidityPercent, isNull);
      expect(block.recommendation, isNull);
    });

    test('today_summary maps counters', () {
      final block = sduiBlockFromJson({
        'type': 'today_summary',
        'total': 5,
        'done': 2,
        'remaining': 3,
        'overdue': 1,
      });

      expect(
        block,
        const SduiBlock.todaySummary(
          total: 5,
          done: 2,
          remaining: 3,
          overdue: 1,
        ),
      );
    });

    test('today_tasks maps counters + tasks with normalized type → CareTaskType',
        () {
      final block = sduiBlockFromJson({
        'type': 'today_tasks',
        'completedCount': 1,
        'totalCount': 3,
        'tasks': [
          {
            'scheduleId': 1,
            'plantId': 42,
            'plantName': 'Фикус',
            'type': 'FERTILIZE',
            'dueAt': '2026-05-27T09:00:00Z',
          },
          {
            'scheduleId': 2,
            'plantId': 7,
            'plantName': 'Монстера',
            'type': 'WATER',
            'dueAt': '2026-05-27T18:30:00Z',
          },
        ],
      }) as SduiTodayTasksBlock;

      expect(block.completedCount, 1);
      expect(block.totalCount, 3);
      expect(block.tasks, hasLength(2));

      final first = block.tasks.first;
      expect(first.scheduleId, 1);
      expect(first.plantId, 42);
      expect(first.plantName, 'Фикус');
      // FERTILIZE (нормализованная форма) → fertilizing (доменный тип).
      expect(first.type, CareTaskType.fertilizing);
      expect(first.dueAt, DateTime.utc(2026, 5, 27, 9));
      expect(first.dueAt.isUtc, isTrue);

      expect(block.tasks[1].type, CareTaskType.watering);
    });

    test('today_tasks soft-handles unknown task type and missing dueAt', () {
      final block = sduiBlockFromJson({
        'type': 'today_tasks',
        'completedCount': 0,
        'totalCount': 1,
        'tasks': [
          {
            'scheduleId': 9,
            'plantId': 1,
            'plantName': 'X',
            // Новый/неизвестный тип не роняет разбор (forward-compat).
            'type': 'TELEPORT',
          },
        ],
      }) as SduiTodayTasksBlock;

      expect(block.tasks.first.type, CareTaskType.unknown);
      // Без dueAt разбор не падает — задача всё равно создаётся.
      expect(block.tasks, hasLength(1));
    });

    test('today_tasks SOIL_CHECK maps to soilCheck', () {
      final block = sduiBlockFromJson({
        'type': 'today_tasks',
        'completedCount': 0,
        'totalCount': 1,
        'tasks': [
          {
            'scheduleId': 1,
            'plantId': 1,
            'plantName': 'X',
            'type': 'SOIL_CHECK',
            'dueAt': '2026-05-27T09:00:00Z',
          },
        ],
      }) as SduiTodayTasksBlock;

      expect(block.tasks.first.type, CareTaskType.soilCheck);
    });

    test('location_chips maps each chip to GardenLocation', () {
      final block = sduiBlockFromJson({
        'type': 'location_chips',
        'locations': [
          {'id': 1, 'name': 'Кухня', 'emoji': '🍳'},
          {'id': 2, 'name': 'Спальня'},
        ],
      }) as SduiLocationChipsBlock;

      expect(block.locations, hasLength(2));
      expect(block.locations.first.id, 1);
      expect(block.locations.first.name, 'Кухня');
      expect(block.locations.first.emoji, '🍳');
      expect(block.locations[1].emoji, isNull);
    });

    test('plant_grid maps items with log_care action', () {
      final block = sduiBlockFromJson({
        'type': 'plant_grid',
        'plants': [
          {
            'id': 7,
            'name': 'Монстера',
            'locationName': 'Кухня',
            'action': {
              'kind': 'log_care',
              'method': 'POST',
              'path': '/care-events',
              'payloadTemplate': {'plantId': 7, 'type': 'WATER'},
            },
          },
          {'id': 8, 'name': 'Кактус'},
        ],
      }) as SduiPlantGridBlock;

      expect(block.plants, hasLength(2));
      final first = block.plants.first;
      expect(first.id, 7);
      expect(first.name, 'Монстера');
      expect(first.locationName, 'Кухня');
      expect(first.action, isNotNull);
      expect(first.action!.kind, SduiActionKind.logCare);
      expect(first.action!.method, 'POST');
      expect(first.action!.path, '/care-events');
      expect(first.action!.payload, {'plantId': 7, 'type': 'WATER'});
      // Второй элемент без действия.
      expect(block.plants[1].action, isNull);
    });

    test('plant_grid action with unknown kind degrades to unknown', () {
      final block = sduiBlockFromJson({
        'type': 'plant_grid',
        'plants': [
          {
            'id': 1,
            'name': 'X',
            'action': {
              'kind': 'teleport_plant',
              'method': 'POST',
              'path': '/whatever',
            },
          },
        ],
      }) as SduiPlantGridBlock;

      expect(block.plants.first.action!.kind, SduiActionKind.unknown);
    });

    test('unknown type → null (skipped by repository)', () {
      final block = sduiBlockFromJson({
        'type': 'super_future_block',
        'payload': 'whatever',
      });

      expect(block, isNull);
    });

    test('missing type → null', () {
      expect(sduiBlockFromJson({'available': true}), isNull);
    });
  });
}
