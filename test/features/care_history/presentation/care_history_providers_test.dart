import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/care_history/data/care_history_repository_provider.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_page.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_repository.dart';
import 'package:plantcare_mobile/features/care_history/presentation/care_history_providers.dart';
import 'package:plantcare_mobile/features/care_history/presentation/care_history_state.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';

class _MockRepo extends Mock implements CareHistoryRepository {}

const _plantId = 42;
const _pageSize = 50;

CareHistoryEntry _entry(int id, {CareEventKind kind = CareEventKind.water}) =>
    CareHistoryEntry(
      id: id,
      plantId: _plantId,
      plantName: 'Фикус',
      kind: kind,
      performedAt: DateTime.utc(2026, 5, 27, 8),
      onTime: id.isEven,
    );

CareHistoryPage _page({
  required List<CareHistoryEntry> items,
  required int total,
  required int offset,
}) =>
    CareHistoryPage(items: items, total: total, limit: _pageSize, offset: offset);

ProviderContainer _containerWith(CareHistoryRepository repo) {
  final container = ProviderContainer(
    overrides: [careHistoryRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписка удерживает autoDispose family-провайдер живым между чтениями.
void _keepAlive(ProviderContainer container) {
  final sub =
      container.listen(careHistoryControllerProvider(_plantId), (_, _) {});
  addTearDown(sub.close);
}

/// Подписывается на провайдер и ждёт перехода в ошибку (подписка удерживает
/// autoDispose-провайдер живым; как в catalog_providers_test).
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

  group('CareHistoryController initial load', () {
    test('should_request_first_page_with_limit_50_offset_0', () async {
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 2, offset: 0),
        ),
      );
      final container = _containerWith(repo);

      final state =
          await container.read(careHistoryControllerProvider(_plantId).future);

      expect(state.entries.map((e) => e.id), [1, 2]);
      expect(state.total, 2);
      expect(state.offset, 2);
      expect(state.hasMore, isFalse);
      verify(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .called(1);
    });

    test('should_throw_ApiError_into_AsyncError_when_first_page_fails',
        () async {
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final error = await _awaitError<CareHistoryState>(
        container,
        (listener) =>
            container.listen(careHistoryControllerProvider(_plantId), listener),
      );

      expect(error, const ApiError.network());
    });
  });

  group('CareHistoryController loadMore', () {
    test('should_append_next_page_and_advance_offset', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 4, offset: 0),
        ),
      );
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(3), _entry(4)], total: 4, offset: 2),
        ),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      await container
          .read(careHistoryControllerProvider(_plantId).notifier)
          .loadMore();

      final state =
          container.read(careHistoryControllerProvider(_plantId)).value!;
      expect(state.entries.map((e) => e.id), [1, 2, 3, 4]);
      expect(state.offset, 4);
      expect(state.hasMore, isFalse);
      // Вторая страница запрошена с offset = числу уже загруженных.
      verify(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .called(1);
    });

    test('should_be_noop_when_hasMore_false', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 2, offset: 0),
        ),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      await container
          .read(careHistoryControllerProvider(_plantId).notifier)
          .loadMore();

      // Только первичный запрос; дозагрузки не было.
      verify(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .called(1);
      verifyNever(() =>
          repo.getHistoryPage(_plantId, limit: any(named: 'limit'), offset: 2));
    });

    test('should_not_start_second_loadMore_while_one_in_flight', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 10, offset: 0),
        ),
      );
      final pending = Completer<Result<CareHistoryPage>>();
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .thenAnswer((_) => pending.future);
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      final notifier =
          container.read(careHistoryControllerProvider(_plantId).notifier);

      final first = notifier.loadMore();
      // Пока первая дозагрузка висит — вторая должна быть no-op (isLoadingMore).
      await notifier.loadMore();

      final during =
          container.read(careHistoryControllerProvider(_plantId)).value!;
      expect(during.isLoadingMore, isTrue);

      pending.complete(
        Result.success(
          _page(items: [_entry(3), _entry(4)], total: 10, offset: 2),
        ),
      );
      await first;

      // Ровно один запрос второй страницы (вторая loadMore отброшена).
      verify(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .called(1);
    });

    test('should_set_loadMoreError_and_keep_list_when_loadMore_fails',
        () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 4, offset: 0),
        ),
      );
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      await container
          .read(careHistoryControllerProvider(_plantId).notifier)
          .loadMore();

      final after = container.read(careHistoryControllerProvider(_plantId));
      // Провайдер НЕ в AsyncError — список сохранён, ошибка в loadMoreError.
      expect(after.hasError, isFalse);
      expect(after.value!.entries.map((e) => e.id), [1, 2]);
      expect(after.value!.loadMoreError, const ApiError.network());
      expect(after.value!.isLoadingMore, isFalse);
    });

    test('should_recover_on_retryLoadMore_after_failure', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 4, offset: 0),
        ),
      );
      var calls = 0;
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .thenAnswer((_) async {
        calls++;
        if (calls == 1) return const Result.failure(ApiError.network());
        return Result.success(
          _page(items: [_entry(3), _entry(4)], total: 4, offset: 2),
        );
      });
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      await container
          .read(careHistoryControllerProvider(_plantId).notifier)
          .loadMore();
      await container
          .read(careHistoryControllerProvider(_plantId).notifier)
          .retryLoadMore();

      final after =
          container.read(careHistoryControllerProvider(_plantId)).value!;
      expect(after.entries.map((e) => e.id), [1, 2, 3, 4]);
      expect(after.loadMoreError, isNull);
    });
  });

  group('CareHistoryController setFilter', () {
    test('should_narrow_visibleEntries_to_selected_kind_without_network',
        () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(
            items: [
              _entry(1, kind: CareEventKind.water),
              _entry(2, kind: CareEventKind.spray),
              _entry(3, kind: CareEventKind.water),
            ],
            total: 3,
            offset: 0,
          ),
        ),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      container
          .read(careHistoryControllerProvider(_plantId).notifier)
          .setFilter(CareEventKind.water);

      final state =
          container.read(careHistoryControllerProvider(_plantId)).value!;
      expect(state.filter, CareEventKind.water);
      // Накопленный список не тронут, сужается только visibleEntries.
      expect(state.entries.map((e) => e.id), [1, 2, 3]);
      expect(state.visibleEntries.map((e) => e.id), [1, 3]);
      // setFilter сети не дёргает.
      verify(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .called(1);
      verifyNoMoreInteractions(repo);
    });

    test('should_show_all_entries_when_filter_cleared_to_null', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(
            items: [
              _entry(1, kind: CareEventKind.water),
              _entry(2, kind: CareEventKind.spray),
            ],
            total: 2,
            offset: 0,
          ),
        ),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      final notifier =
          container.read(careHistoryControllerProvider(_plantId).notifier);
      notifier.setFilter(CareEventKind.water);
      notifier.setFilter(null);

      final state =
          container.read(careHistoryControllerProvider(_plantId)).value!;
      expect(state.filter, isNull);
      expect(state.visibleEntries.map((e) => e.id), [1, 2]);
    });
  });

  group('careHistorySummaryProvider', () {
    test('should_aggregate_total_onTimeCount_and_streak', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          // id 2,4 → onTime true (id.isEven); id 1,3 → false.
          _page(
            items: [_entry(1), _entry(2), _entry(3), _entry(4)],
            total: 10,
            offset: 0,
          ),
        ),
      );
      when(() => repo.getStreak(_plantId)).thenAnswer(
        (_) async => const Result.success(Streak(plantId: _plantId, count: 5)),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      await container.read(careHistoryStreakProvider(_plantId).future);

      final summary =
          container.read(careHistorySummaryProvider(_plantId));
      expect(summary, isNotNull);
      expect(summary!.total, 10); // из PlantHistoryResponse.total
      expect(summary.loadedCount, 4); // загружено записей
      expect(summary.onTimeCount, 2); // id 2 и 4
      expect(summary.streakCount, 5); // из стрика
    });

    test('should_be_null_while_history_not_loaded', () {
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) => Completer<Result<CareHistoryPage>>().future);
      final container = _containerWith(repo);
      _keepAlive(container);

      // История ещё в loading → сводки нет.
      expect(container.read(careHistorySummaryProvider(_plantId)), isNull);
    });

    test('should_use_streakCount_zero_when_streak_fails', () async {
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(2)], total: 1, offset: 0),
        ),
      );
      when(() => repo.getStreak(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(careHistoryControllerProvider(_plantId).future);
      // Дожидаемся падения стрика (не валит сводку).
      await container
          .read(careHistoryStreakProvider(_plantId).future)
          .then<void>((_) {}, onError: (_) {});

      final summary = container.read(careHistorySummaryProvider(_plantId));
      expect(summary, isNotNull);
      // Стрик упал — показываем 0, сводка по истории остаётся валидной.
      expect(summary!.streakCount, 0);
      expect(summary.total, 1);
    });
  });

  group('careHistoryPlantProvider', () {
    test('should_emit_plant_when_repository_succeeds', () async {
      when(() => repo.getPlant(_plantId)).thenAnswer(
        (_) async => Result.success(
          Plant(id: _plantId, name: 'Фикус', createdAt: DateTime.utc(2026)),
        ),
      );
      final container = _containerWith(repo);

      final plant =
          await container.read(careHistoryPlantProvider(_plantId).future);

      expect(plant.name, 'Фикус');
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(() => repo.getPlant(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.notFound()));
      final container = _containerWith(repo);

      final error = await _awaitError<Plant>(
        container,
        (listener) =>
            container.listen(careHistoryPlantProvider(_plantId), listener),
      );

      expect(error, const ApiError.notFound());
    });
  });
}
