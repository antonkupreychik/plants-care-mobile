import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/plant_events/data/plant_event_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_repository.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_event_type.dart';
import 'package:plantcare_mobile/features/plant_events/domain/plant_events_page.dart';
import 'package:plantcare_mobile/features/plant_events/presentation/plant_events_providers.dart';

class _MockRepo extends Mock implements PlantEventRepository {}

const _plantId = 5;
final _t0 = DateTime.utc(2026, 6, 1, 9);

PlantEvent _event(int id, PlantEventType type) =>
    PlantEvent(id: id, eventType: type, eventDate: _t0);

PlantEventsPage _page(List<PlantEvent> items, int total, int offset) =>
    PlantEventsPage(items: items, total: total, limit: 20, offset: offset);

ProviderContainer _containerWith(PlantEventRepository repo) {
  final container = ProviderContainer(
    overrides: [plantEventRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Waits for a provider to enter an error state via a listener subscription
/// (keeps AutoDispose providers alive until the error fires).
Future<Object?> _awaitError<T>(
  ProviderContainer container,
  ProviderSubscription<AsyncValue<T>> Function(
    void Function(AsyncValue<T>? prev, AsyncValue<T> next) listener,
  ) listen,
) {
  final completer = Completer<Object?>();
  late final ProviderSubscription<AsyncValue<T>> sub;
  sub = listen((_, next) {
    if (next.hasError && !completer.isCompleted) {
      completer.complete(next.error);
    }
  });
  addTearDown(sub.close);
  return completer.future;
}

void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  test('build_should_load_first_page', () async {
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(1, PlantEventType.pruning)], 1, 0),
            ));
    final container = _containerWith(repo);

    final state =
        await container.read(plantEventsControllerProvider(_plantId).future);

    expect(state.items, hasLength(1));
    expect(state.total, 1);
    expect(state.hasMore, isFalse);
    expect(state.offset, 1);
  });

  test('loadMore_should_append_next_page', () async {
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(1, PlantEventType.pruning)], 2, 0),
            ));
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 1))
        .thenAnswer((_) async => Result.success(
              _page([_event(2, PlantEventType.transplant)], 2, 1),
            ));
    final container = _containerWith(repo);

    await container.read(plantEventsControllerProvider(_plantId).future);
    await container
        .read(plantEventsControllerProvider(_plantId).notifier)
        .loadMore();

    final state = container.read(plantEventsControllerProvider(_plantId)).value!;
    expect(state.items, hasLength(2));
    expect(state.hasMore, isFalse);
    expect(state.loadMoreError, isNull);
  });

  test('loadMore_failure_should_set_loadMoreError_keeping_list', () async {
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(1, PlantEventType.pruning)], 2, 0),
            ));
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 1))
        .thenAnswer((_) async => const Result.failure(ApiError.network()));
    final container = _containerWith(repo);

    await container.read(plantEventsControllerProvider(_plantId).future);
    await container
        .read(plantEventsControllerProvider(_plantId).notifier)
        .loadMore();

    final state = container.read(plantEventsControllerProvider(_plantId)).value!;
    expect(state.items, hasLength(1)); // список сохранён
    expect(state.loadMoreError, const ApiError.network());
    expect(state.isLoadingMore, isFalse);
  });

  test('addEvent_success_should_optimistically_prepend_and_return_null',
      () async {
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(1, PlantEventType.pruning)], 1, 0),
            ));
    when(() => repo.addEvent(_plantId, PlantEventType.transplant)).thenAnswer(
      (_) async => Result.success(_event(2, PlantEventType.transplant)),
    );
    final container = _containerWith(repo);

    await container.read(plantEventsControllerProvider(_plantId).future);
    final error = await container
        .read(plantEventsControllerProvider(_plantId).notifier)
        .addEvent(PlantEventType.transplant);

    expect(error, isNull);
    final state = container.read(plantEventsControllerProvider(_plantId)).value!;
    expect(state.items, hasLength(2));
    expect(state.items.first.eventType, PlantEventType.transplant);
    expect(state.total, 2);
  });

  test('addEvent_conflict_should_return_error_and_not_change_list', () async {
    when(() => repo.getEvents(_plantId, limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(1, PlantEventType.pruning)], 1, 0),
            ));
    when(() => repo.addEvent(_plantId, PlantEventType.pruning))
        .thenAnswer((_) async => const Result.failure(ApiError.conflict()));
    final container = _containerWith(repo);

    await container.read(plantEventsControllerProvider(_plantId).future);
    final error = await container
        .read(plantEventsControllerProvider(_plantId).notifier)
        .addEvent(PlantEventType.pruning);

    expect(error, const ApiError.conflict());
    final state = container.read(plantEventsControllerProvider(_plantId)).value!;
    expect(state.items, hasLength(1));
    expect(state.total, 1);
  });

  // ── recentPlantEventsProvider ──────────────────────────────────────────────

  test('recentPlantEvents_should_return_first_three_events_for_given_plantId',
      () async {
    const recentPlantId = 7;
    when(() => repo.getEvents(
          recentPlantId,
          limit: 3, // recentPlantEventsProvider uses limit=3
          offset: 0,
        )).thenAnswer((_) async => Result.success(
          _page(
            [
              _event(1, PlantEventType.pruning),
              _event(2, PlantEventType.soilChange),
              _event(3, PlantEventType.transplant),
            ],
            3,
            0,
          ),
        ));
    final container = _containerWith(repo);

    final events =
        await container.read(recentPlantEventsProvider(recentPlantId).future);

    expect(events, hasLength(3));
    expect(events.first.eventType, PlantEventType.pruning);
    verify(() => repo.getEvents(recentPlantId, limit: 3, offset: 0)).called(1);
  });

  test(
      'recentPlantEvents_for_different_plantIds_are_independent_family_instances',
      () async {
    const plantIdX = 11;
    const plantIdY = 22;
    when(() => repo.getEvents(plantIdX,
            limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(1, PlantEventType.pruning)], 1, 0),
            ));
    when(() => repo.getEvents(plantIdY,
            limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Result.success(
              _page([_event(2, PlantEventType.transplant)], 1, 0),
            ));
    final container = _containerWith(repo);

    final eventsX =
        await container.read(recentPlantEventsProvider(plantIdX).future);
    final eventsY =
        await container.read(recentPlantEventsProvider(plantIdY).future);

    // plantX gets pruning, plantY gets transplant — no cross-contamination.
    expect(eventsX.first.eventType, PlantEventType.pruning);
    expect(eventsY.first.eventType, PlantEventType.transplant);
  });

  test(
      'recentPlantEvents_throws_ApiError_into_AsyncError_when_repo_fails',
      () async {
    const failingPlantId = 99;
    when(() => repo.getEvents(failingPlantId,
            limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => const Result.failure(ApiError.network()));
    final container = _containerWith(repo);

    // Use listener-based helper to avoid autoDispose race on error.
    final error = await _awaitError<List<PlantEvent>>(
      container,
      (listener) =>
          container.listen(recentPlantEventsProvider(failingPlantId), listener),
    );

    expect(error, const ApiError.network());
  });
}
