import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/plant_events/data/fake_plant_event_repository_impl.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_events_page.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

const _plantId = 7;
final _now = DateTime.utc(2026, 6, 1, 9);

PlantEventsPage _page(Result<PlantEventsPage> r) =>
    (r as Success<PlantEventsPage>).value;

void main() {
  late FakePlantEventRepositoryImpl repo;

  setUp(() => repo = FakePlantEventRepositoryImpl(_FixedClock(_now)));

  group('getEvents', () {
    test('should_return_three_seeded_events_newest_first', () async {
      final page = _page(await repo.getEvents(_plantId));

      expect(page.total, 3);
      expect(page.items, hasLength(3));
      // Новые сверху: обрезка (9 дней назад) первой.
      expect(page.items.first.eventType, PlantEventType.pruning);
      expect(page.items.last.eventType, PlantEventType.transplant);
      // Времена в UTC и в прошлом относительно now.
      for (final e in page.items) {
        expect(e.eventDate.isUtc, isTrue);
        expect(e.eventDate.isBefore(_now), isTrue);
      }
    });

    test('should_paginate_with_limit_and_offset', () async {
      final first = _page(await repo.getEvents(_plantId, limit: 2, offset: 0));
      final second = _page(await repo.getEvents(_plantId, limit: 2, offset: 2));

      expect(first.items, hasLength(2));
      expect(first.total, 3);
      expect(first.hasMore, isTrue);
      expect(second.items, hasLength(1));
      expect(second.hasMore, isFalse);
    });
  });

  group('addEvent', () {
    test('should_persist_event_visible_on_next_read', () async {
      final added = await repo.addEvent(_plantId, PlantEventType.pestTreatment);
      expect(added, isA<Success<PlantEvent>>());
      expect(
        (added as Success<PlantEvent>).value.eventType,
        PlantEventType.pestTreatment,
      );

      final page = _page(await repo.getEvents(_plantId));
      expect(page.total, 4);
      // Добавленное — новейшее, сверху.
      expect(page.items.first.eventType, PlantEventType.pestTreatment);
    });

    test('should_isolate_events_per_plant', () async {
      await repo.addEvent(_plantId, PlantEventType.pruning);

      final other = _page(await repo.getEvents(99));
      // Другое растение засеяно своим набором, не видит добавленного.
      expect(other.total, 3);
    });
  });
}
