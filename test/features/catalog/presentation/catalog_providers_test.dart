import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/catalog/data/catalog_repository_provider.dart';
import 'package:plantcare_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:plantcare_mobile/features/catalog/domain/species.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_detail.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_page.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/catalog/presentation/species_list_state.dart';

class _MockRepo extends Mock implements CatalogRepository {}

SpeciesPage _pageOf({
  required List<int> ids,
  required int total,
  required int offset,
}) =>
    SpeciesPage(
      items: ids.map((i) => Species(id: i, name: 'S$i')).toList(),
      total: total,
      offset: offset,
      limit: kSpeciesPageLimit,
    );

ProviderContainer _containerWith(CatalogRepository repo) {
  final container = ProviderContainer(
    overrides: [catalogRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписка удерживает AutoDispose speciesListProvider живым между чтениями.
void _keepListAlive(ProviderContainer container) {
  final sub = container.listen(speciesListProvider, (_, _) {});
  addTearDown(sub.close);
}

/// Подписывается на провайдер и ждёт перехода в ошибку (подписка удерживает
/// AutoDispose-провайдер живым; как в plant_card_providers_test).
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

  group('SpeciesQuery', () {
    test('should_start_empty', () {
      final container = _containerWith(repo);

      expect(container.read(speciesQueryProvider), '');
    });

    test('should_set_trimmed_query', () {
      final container = _containerWith(repo);

      container.read(speciesQueryProvider.notifier).setQuery('  мон  ');

      expect(container.read(speciesQueryProvider), 'мон');
    });

    test('should_dedupe_same_query_no_state_change', () {
      final container = _containerWith(repo);
      container.read(speciesQueryProvider.notifier).setQuery('мон');

      var notified = 0;
      final sub =
          container.listen(speciesQueryProvider, (_, _) => notified++);
      addTearDown(sub.close);

      // Тот же запрос (с другими пробелами) → trim к тому же → no-op.
      container.read(speciesQueryProvider.notifier).setQuery(' мон ');

      expect(notified, 0);
      expect(container.read(speciesQueryProvider), 'мон');
    });
  });

  group('speciesListProvider initial load', () {
    test('should_emit_items_total_and_hasMore_when_more_pages_remain',
        () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 5, offset: 0)),
      );
      final container = _containerWith(repo);

      final state = await container.read(speciesListProvider.future);

      expect(state.items.map((s) => s.id), [1, 2]);
      expect(state.total, 5);
      expect(state.hasMore, isTrue); // 2 < 5
      expect(state.isLoadingMore, isFalse);
      expect(state.loadMoreError, isNull);
    });

    test('should_set_hasMore_false_when_first_page_covers_total', () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 2, offset: 0)),
      );
      final container = _containerWith(repo);

      final state = await container.read(speciesListProvider.future);

      expect(state.hasMore, isFalse); // 2 >= 2
    });

    test('should_throw_ApiError_into_AsyncError_when_initial_load_fails',
        () async {
      when(() => repo.searchSpecies(
            query: any(named: 'query'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final error = await _awaitError<SpeciesListState>(
        container,
        (listener) => container.listen(speciesListProvider, listener),
      );

      expect(error, const ApiError.network());
    });
  });

  group('speciesListProvider loadMore', () {
    test('should_accumulate_pages_and_update_total_on_loadMore', () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 4, offset: 0)),
      );
      when(() => repo.searchSpecies(
            query: '',
            offset: 2,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [3, 4], total: 4, offset: 2)),
      );
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);
      await container.read(speciesListProvider.notifier).loadMore();

      final state = container.read(speciesListProvider).value!;
      // Старые + новые, в порядке загрузки.
      expect(state.items.map((s) => s.id), [1, 2, 3, 4]);
      expect(state.total, 4);
      expect(state.hasMore, isFalse); // 4 >= 4
      expect(state.isLoadingMore, isFalse);
      // Второй запрос ушёл с offset = items.length (2).
      verify(() => repo.searchSpecies(
            query: '',
            offset: 2,
            limit: kSpeciesPageLimit,
          )).called(1);
    });

    test('should_keep_content_in_AsyncData_during_loadMore_not_loading',
        () async {
      final pending = Completer<Result<SpeciesPage>>();
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 4, offset: 0)),
      );
      when(() => repo.searchSpecies(
            query: '',
            offset: 2,
            limit: kSpeciesPageLimit,
          )).thenAnswer((_) => pending.future);
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);
      final future = container.read(speciesListProvider.notifier).loadMore();

      // Пока вторая страница грузится: контент сохранён, флаг выставлен,
      // провайдер НЕ в loading.
      final during = container.read(speciesListProvider);
      expect(during.isLoading, isFalse);
      expect(during.value!.isLoadingMore, isTrue);
      expect(during.value!.items.map((s) => s.id), [1, 2]);

      pending.complete(
        Result.success(_pageOf(ids: [3, 4], total: 4, offset: 2)),
      );
      await future;

      expect(container.read(speciesListProvider).value!.isLoadingMore, isFalse);
    });

    test('should_be_noop_when_hasMore_false', () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 2, offset: 0)),
      );
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);
      await container.read(speciesListProvider.notifier).loadMore();

      // Только первичный запрос; второй (offset 2) не уходил.
      verify(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).called(1);
      verifyNever(() => repo.searchSpecies(
            query: any(named: 'query'),
            offset: 2,
            limit: any(named: 'limit'),
          ));
    });

    test(
        'should_set_loadMoreError_and_keep_items_when_loadMore_fails_then_retry_recovers',
        () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 4, offset: 0)),
      );
      // Первая дозагрузка падает, повтор — успех.
      var loadMoreCalls = 0;
      when(() => repo.searchSpecies(
            query: '',
            offset: 2,
            limit: kSpeciesPageLimit,
          )).thenAnswer((_) async {
        loadMoreCalls++;
        if (loadMoreCalls == 1) {
          return const Result.failure(ApiError.network());
        }
        return Result.success(_pageOf(ids: [3, 4], total: 4, offset: 2));
      });
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);
      await container.read(speciesListProvider.notifier).loadMore();

      // Контент сохранён, ошибка в loadMoreError (НЕ AsyncError провайдера).
      final afterFail = container.read(speciesListProvider);
      expect(afterFail.hasError, isFalse);
      expect(afterFail.value!.items.map((s) => s.id), [1, 2]);
      expect(afterFail.value!.loadMoreError, const ApiError.network());
      expect(afterFail.value!.isLoadingMore, isFalse);

      await container.read(speciesListProvider.notifier).retryLoadMore();

      final afterRetry = container.read(speciesListProvider).value!;
      expect(afterRetry.items.map((s) => s.id), [1, 2, 3, 4]);
      expect(afterRetry.loadMoreError, isNull);
    });
  });

  group('speciesListProvider reset on query change', () {
    test('should_reload_from_offset_0_with_new_query_when_query_changes',
        () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [1, 2], total: 2, offset: 0)),
      );
      when(() => repo.searchSpecies(
            query: 'фикус',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(ids: [9], total: 1, offset: 0)),
      );
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);

      container.read(speciesQueryProvider.notifier).setQuery('фикус');
      final reloaded = await container.read(speciesListProvider.future);

      expect(reloaded.items.map((s) => s.id), [9]);
      expect(reloaded.total, 1);
      // Новый запрос ушёл с правильным q и offset 0.
      verify(() => repo.searchSpecies(
            query: 'фикус',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).called(1);
    });
  });

  group('loadMore race on query change', () {
    test(
        'should_discard_stale_loadMore_success_when_query_changed_mid_flight',
        () async {
      // Первая страница пустого запроса: 20 из 40 → hasMore.
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(
          ids: List.generate(20, (i) => i + 1),
          total: 40,
          offset: 0,
        )),
      );
      // Дозагрузка старого запроса (offset 20) «висит» на Completer.
      final staleLoadMore = Completer<Result<SpeciesPage>>();
      when(() => repo.searchSpecies(
            query: '',
            offset: 20,
            limit: kSpeciesPageLimit,
          )).thenAnswer((_) => staleLoadMore.future);
      // Новый запрос «монстера»: первая страница 5 из 5.
      when(() => repo.searchSpecies(
            query: 'монстера',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(
          ids: [101, 102, 103, 104, 105],
          total: 5,
          offset: 0,
        )),
      );
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);
      // loadMore для offset=20 уходит, но не завершается (Completer висит).
      final staleFuture =
          container.read(speciesListProvider.notifier).loadMore();

      // Пока дозагрузка в полёте — меняем строку поиска. Riverpod пересоздаёт
      // нотифаер и грузит первую страницу нового запроса.
      container.read(speciesQueryProvider.notifier).setQuery('монстера');
      final fresh = await container.read(speciesListProvider.future);

      // Новая первая страница уже отдана.
      expect(fresh.items.map((s) => s.id), [101, 102, 103, 104, 105]);
      expect(fresh.total, 5);

      // Теперь завершаем «зависшую» дозагрузку старого запроса stale-страницей.
      staleLoadMore.complete(
        Result.success(_pageOf(ids: [21, 22], total: 40, offset: 20)),
      );
      await staleFuture;

      // Результат старого loadMore отброшен query-guard'ом: список и total
      // принадлежат новому запросу, stale-страница НЕ дописана.
      final result = container.read(speciesListProvider).value!;
      expect(result.items.map((s) => s.id), [101, 102, 103, 104, 105]);
      expect(result.total, 5);
      expect(result.isLoadingMore, isFalse);
      expect(result.loadMoreError, isNull);
    });

    test(
        'should_not_set_loadMoreError_on_new_list_when_stale_loadMore_fails_after_query_change',
        () async {
      when(() => repo.searchSpecies(
            query: '',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(
          ids: List.generate(20, (i) => i + 1),
          total: 40,
          offset: 0,
        )),
      );
      final staleLoadMore = Completer<Result<SpeciesPage>>();
      when(() => repo.searchSpecies(
            query: '',
            offset: 20,
            limit: kSpeciesPageLimit,
          )).thenAnswer((_) => staleLoadMore.future);
      when(() => repo.searchSpecies(
            query: 'монстера',
            offset: 0,
            limit: kSpeciesPageLimit,
          )).thenAnswer(
        (_) async => Result.success(_pageOf(
          ids: [101, 102, 103, 104, 105],
          total: 5,
          offset: 0,
        )),
      );
      final container = _containerWith(repo);
      _keepListAlive(container);

      await container.read(speciesListProvider.future);
      final staleFuture =
          container.read(speciesListProvider.notifier).loadMore();

      container.read(speciesQueryProvider.notifier).setQuery('монстера');
      await container.read(speciesListProvider.future);

      // Старая дозагрузка падает ошибкой — но запрос уже сменился.
      staleLoadMore.complete(const Result.failure(ApiError.network()));
      await staleFuture;

      // loadMoreError НЕ должен протечь на новый список.
      final result = container.read(speciesListProvider).value!;
      expect(result.items.map((s) => s.id), [101, 102, 103, 104, 105]);
      expect(result.loadMoreError, isNull);
      expect(result.isLoadingMore, isFalse);
    });
  });

  group('speciesDetailProvider', () {
    const id = 5;

    test('should_emit_detail_when_repository_succeeds', () async {
      const detail = SpeciesDetail(id: id, name: 'Фикус');
      when(() => repo.getSpecies(id))
          .thenAnswer((_) async => const Result.success(detail));
      final container = _containerWith(repo);

      final value = await container.read(speciesDetailProvider(id).future);

      expect(value, detail);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(() => repo.getSpecies(id))
          .thenAnswer((_) async => const Result.failure(ApiError.notFound()));
      final container = _containerWith(repo);

      final error = await _awaitError<SpeciesDetail>(
        container,
        (listener) => container.listen(speciesDetailProvider(id), listener),
      );

      expect(error, const ApiError.notFound());
    });
  });
}
