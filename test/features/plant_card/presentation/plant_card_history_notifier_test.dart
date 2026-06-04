import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_card_repository.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_history_page.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_history_state.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';

class _MockRepo extends Mock implements PlantCardRepository {}

const _plantId = 42;
const _pageSize = 5;

CareHistoryEntry _entry(int id) => CareHistoryEntry(
      id: id,
      plantId: _plantId,
      plantName: 'Фикус',
      kind: CareEventKind.water,
      performedAt: DateTime.utc(2026, 5, 27, 8),
      onTime: id.isEven,
    );

PlantHistoryPage _page({
  required List<CareHistoryEntry> items,
  required int total,
  int offset = 0,
}) =>
    PlantHistoryPage(
      items: items,
      total: total,
      limit: _pageSize,
      offset: offset,
    );

ProviderContainer _containerWith(PlantCardRepository repo) {
  final container = ProviderContainer(
    overrides: [plantCardRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписка удерживает autoDispose-провайдер живым между чтениями.
void _keepAlive(ProviderContainer container) {
  final sub =
      container.listen(plantCardHistoryProvider(_plantId), (_, _) {});
  addTearDown(sub.close);
}

/// Ждёт AsyncData с ненулевым значением (первичная загрузка завершена).
Future<PlantCardHistoryState> _awaitData(ProviderContainer container) async {
  _keepAlive(container);
  return container.read(plantCardHistoryProvider(_plantId).future);
}

/// Подписывается и ждёт перехода в AsyncError.
Future<Object?> _awaitError(ProviderContainer container) {
  final completer = Completer<Object?>();
  late final ProviderSubscription<AsyncValue<PlantCardHistoryState>> sub;
  sub = container.listen(plantCardHistoryProvider(_plantId), (_, next) {
    if (next.hasError && !completer.isCompleted) {
      completer.complete(next.error);
    }
  });
  addTearDown(sub.close);
  return completer.future;
}

void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    // Fallback для методов, которые не нужны в конкретном тесте.
    when(() => repo.getPlant(any())).thenAnswer(
      (_) async => const Result.failure(ApiError.notFound()),
    );
    when(() => repo.getStreak(any())).thenAnswer(
      (_) async => const Result.failure(ApiError.notFound()),
    );
    when(() => repo.getPlantHealth(any())).thenAnswer(
      (_) async => const Result.failure(ApiError.notFound()),
    );
    when(() => repo.getHistory(any())).thenAnswer(
      (_) async => const Result.success(<CareHistoryEntry>[]),
    );
  });

  group('PlantCardHistory initial load', () {
    test('should_load_first_5_entries_on_build', () async {
      final entries = List.generate(5, _entry);
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer((_) async => Result.success(_page(items: entries, total: 8)));

      final container = _containerWith(repo);
      final state = await _awaitData(container);

      expect(state.items, entries);
      expect(state.total, 8);
      expect(state.offset, 5);
      expect(state.hasMore, isTrue);
      expect(state.isLoadingMore, isFalse);
      expect(state.loadMoreError, isNull);
    });

    test('should_set_hasMore_false_when_all_entries_fit_first_page', () async {
      final entries = List.generate(3, _entry);
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer((_) async => Result.success(_page(items: entries, total: 3)));

      final container = _containerWith(repo);
      final state = await _awaitData(container);

      expect(state.items, entries);
      expect(state.hasMore, isFalse);
    });

    test('should_propagate_ApiError_into_AsyncError_when_initial_load_fails',
        () async {
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer(
        (_) async => const Result.failure(ApiError.network()),
      );

      final container = _containerWith(repo);
      final error = await _awaitError(container);

      expect(error, const ApiError.network());
    });
  });

  group('PlantCardHistory loadMore', () {
    test('should_append_items_and_advance_offset_after_loadMore', () async {
      final first = List.generate(5, _entry);
      final second = List.generate(3, (i) => _entry(i + 5));
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer(
        (_) async => Result.success(_page(items: first, total: 8)),
      );
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 5),
      ).thenAnswer(
        (_) async => Result.success(
          _page(items: second, total: 8, offset: 5),
        ),
      );

      final container = _containerWith(repo);
      await _awaitData(container);

      await container
          .read(plantCardHistoryProvider(_plantId).notifier)
          .loadMore();

      final state = container.read(plantCardHistoryProvider(_plantId)).value!;

      expect(state.items, [...first, ...second]);
      expect(state.total, 8);
      expect(state.offset, 8);
      expect(state.hasMore, isFalse);
      expect(state.isLoadingMore, isFalse);
    });

    test('should_set_hasMore_false_after_all_items_loaded', () async {
      final first = List.generate(5, _entry);
      final second = [_entry(5), _entry(6), _entry(7)];
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer(
        (_) async => Result.success(_page(items: first, total: 8)),
      );
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 5),
      ).thenAnswer(
        (_) async => Result.success(
          _page(items: second, total: 8, offset: 5),
        ),
      );

      final container = _containerWith(repo);
      await _awaitData(container);
      await container
          .read(plantCardHistoryProvider(_plantId).notifier)
          .loadMore();

      final state = container.read(plantCardHistoryProvider(_plantId)).value!;

      expect(state.hasMore, isFalse);
      expect(state.items.length, 8);
    });

    test('should_be_noop_when_hasMore_is_false', () async {
      final entries = List.generate(3, _entry);
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer(
        (_) async => Result.success(_page(items: entries, total: 3)),
      );

      final container = _containerWith(repo);
      await _awaitData(container);

      await container
          .read(plantCardHistoryProvider(_plantId).notifier)
          .loadMore();

      // Вторичного вызова не было — только первичный (offset=0).
      verify(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).called(1);
      verifyNever(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 3),
      );
    });

    test('should_put_error_in_loadMoreError_and_preserve_items_on_failure',
        () async {
      final first = List.generate(5, _entry);
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 0),
      ).thenAnswer(
        (_) async => Result.success(_page(items: first, total: 8)),
      );
      when(
        () => repo.getHistoryPage(_plantId, limit: _pageSize, offset: 5),
      ).thenAnswer(
        (_) async => const Result.failure(ApiError.network()),
      );

      final container = _containerWith(repo);
      await _awaitData(container);

      await container
          .read(plantCardHistoryProvider(_plantId).notifier)
          .loadMore();

      final state = container.read(plantCardHistoryProvider(_plantId)).value!;

      // Список не очищен, ошибка дозагрузки — отдельное поле.
      expect(state.items, first);
      expect(state.loadMoreError, const ApiError.network());
      expect(state.isLoadingMore, isFalse);
    });
  });
}
