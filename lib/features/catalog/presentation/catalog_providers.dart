import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/catalog_repository_provider.dart';
import '../domain/species_detail.dart';
import '../domain/species_page.dart';
import 'species_list_state.dart';

part 'catalog_providers.g.dart';

/// State-слой каталога видов (экраны 12 «Список» и 13 «Деталь»).
///
/// Контракт для ui-builder:
/// - [speciesQueryProvider] — текущая строка поиска (`Notifier<String>`).
///   UI дебаунсит ввод (Timer, забота UI) и вызывает `setQuery(text)`.
/// - [speciesListProvider] — `AsyncValue<SpeciesListState>` для текущего запроса.
///   `state.items` / `state.hasMore` / `state.isLoadingMore` / `state.loadMoreError`.
///   Методы нотифаера: `loadMore()`, `retryLoadMore()`. Первичный retry — через
///   `ref.invalidate(speciesListProvider)` (стандартный паттерн `AsyncValue`).
/// - [speciesDetailProvider] — `AsyncValue<SpeciesDetail>` по `id` (family).

/// Размер страницы списка видов (backend обрезает до 100).
const int kSpeciesPageLimit = 20;

/// Текущая строка поиска по каталогу (committed-значение, не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Дебаунс сырого ввода — забота UI
/// (Timer), сюда кладётся уже «успокоившееся» значение через [setQuery].
/// `keepAlive`: строка переживает уход с экрана списка на деталь и обратно
/// (пользователь возвращается к тем же результатам). Сброс — `setQuery('')`.
@Riverpod(keepAlive: true)
class SpeciesQuery extends _$SpeciesQuery {
  @override
  String build() => '';

  /// Заменяет строку поиска. `speciesListProvider` зависит от неё через
  /// `ref.watch` → при изменении пересоздаётся и грузит первую страницу заново.
  void setQuery(String query) {
    final trimmed = query.trim();
    if (trimmed == state) return;
    state = trimmed;
  }
}

/// Аккумулирующий пагинированный список видов под текущей строкой поиска.
///
/// `watch(speciesQueryProvider)` в [build]: смена строки поиска пересоздаёт
/// нотифаер (Riverpod сбрасывает state в loading) и грузит первую страницу с
/// начала — отдельный reset не нужен. Дальше [loadMore] дозагружает страницы и
/// **аккумулирует** их в [SpeciesListState.items], пока `hasMore` (по `total`
/// из `PageResponse`).
@riverpod
class SpeciesList extends _$SpeciesList {
  @override
  Future<SpeciesListState> build() async {
    final query = ref.watch(speciesQueryProvider);
    final page = await _fetch(query: query, offset: 0);
    return SpeciesListState(
      items: page.items,
      total: page.total,
    );
  }

  /// Дозагружает следующую страницу и дописывает её к текущему списку.
  ///
  /// No-op, если ещё нет данных (идёт первичная загрузка/ошибка), уже грузится
  /// или больше нечего грузить. Ошибку страницы кладёт в
  /// [SpeciesListState.loadMoreError] (показанный список сохраняется), а не в
  /// `AsyncError` всего провайдера. Результат отбрасывается, если за время
  /// запроса сменилась строка поиска (защита от гонки stale-страницы).
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    // Фиксируем запрос, под который грузим страницу. Если во время полёта
    // запроса пользователь сменит строку поиска, `build()` пересоздаст state
    // для нового запроса — долетевший континуэйшн старого `loadMore` не должен
    // дописывать stale-страницу к новому списку.
    final capturedQuery = ref.read(speciesQueryProvider);

    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final result = await ref
        .read(catalogRepositoryProvider)
        .searchSpecies(
          query: capturedQuery,
          offset: current.items.length,
          limit: kSpeciesPageLimit,
        );

    // Нотифаер autoDispose — мог быть утилизирован за время await.
    if (!ref.mounted) return;
    // Запрос сменился, пока летел ответ — отбрасываем stale-страницу целиком
    // (и успех, и ошибку): актуальный state уже принадлежит новому запросу.
    if (ref.read(speciesQueryProvider) != capturedQuery) return;

    // Аккумулируем от свежеперечитанного состояния, а не от захваченного
    // `current`: за время await state мог поменяться в рамках того же запроса.
    final latest = state.value;
    if (latest == null) return;

    switch (result) {
      case Success(:final value):
        state = AsyncData(
          latest.copyWith(
            items: [...latest.items, ...value.items],
            total: value.total,
            isLoadingMore: false,
            loadMoreError: null,
          ),
        );
      case Failure(:final error):
        state = AsyncData(
          latest.copyWith(isLoadingMore: false, loadMoreError: error),
        );
    }
  }

  /// Повторяет неудавшуюся дозагрузку (`loadMoreError` → попытка снова).
  Future<void> retryLoadMore() => loadMore();

  /// Запрос страницы через репозиторий; `Result.failure` пробрасывается как
  /// бросок `ApiError` — Riverpod упакует его в `AsyncError` для первичной
  /// загрузки (UI рисует ошибку экрана).
  Future<SpeciesPage> _fetch({required String query, required int offset}) async {
    final result = await ref.read(catalogRepositoryProvider).searchSpecies(
          query: query,
          offset: offset,
          limit: kSpeciesPageLimit,
        );
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }
}

/// Деталь вида (`GET /api/v1/species/{id}`, scope none). Family по `id`,
/// как `plantDetailProvider`. `AsyncError` несёт типизированный `ApiError`.
@riverpod
Future<SpeciesDetail> speciesDetail(Ref ref, int id) async {
  final result = await ref.watch(catalogRepositoryProvider).getSpecies(id);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
