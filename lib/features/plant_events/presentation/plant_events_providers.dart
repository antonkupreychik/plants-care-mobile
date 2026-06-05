import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/plant_event_repository_provider.dart';
import '../domain/plant_event.dart';
import '../domain/plant_event_type.dart';
import '../domain/plant_events_page.dart';
import 'plant_events_state.dart';

part 'plant_events_providers.g.dart';

/// State-слой журнала событий растения.
///
/// Контракт для UI:
/// - [plantEventsControllerProvider] (family по `plantId`) —
///   `AsyncValue<PlantEventsState>` (loading / error / data). В `AsyncError`
///   лежит типизированный [ApiError]. Методы контроллера: `loadMore()`,
///   `retryLoadMore()`, `refresh()`, `addEvent(type)`.
/// - [recentPlantEventsProvider] (family по `plantId`) —
///   `AsyncValue<List<PlantEvent>>`: последние [_recentLimit] событий для секции
///   в карточке растения (02). Отдельный лёгкий провайдер — карточке не нужна
///   пагинация, поэтому она не подписывается на контроллер.

/// Размер первичной и последующих страниц журнала.
const int _pageSize = 20;

/// Сколько последних событий показывает секция в карточке растения (02).
const int _recentLimit = 3;

/// Контроллер ленты событий с накоплением страниц.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
/// перечитывает первую страницу для синхронизации с источником (паттерн
/// `CareHistoryController` + оптимистичное добавление).
@riverpod
class PlantEventsController extends _$PlantEventsController {
  @override
  Future<PlantEventsState> build(int plantId) async {
    final page = await _fetchPage(offset: 0);
    return PlantEventsState(
      items: page.items,
      total: page.total,
      offset: page.items.length,
    );
  }

  /// Подгрузить следующую страницу и аппендить к накопленным.
  ///
  /// No-op, если данных ещё нет, уже грузится или больше нечего грузить. Ошибку
  /// страницы кладёт в [PlantEventsState.loadMoreError] (показанный список
  /// сохраняется), а не в `AsyncError` всего провайдера.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final result = await ref
        .read(plantEventRepositoryProvider)
        .getEvents(plantId, limit: _pageSize, offset: current.offset);

    if (!ref.mounted) return;
    final latest = state.value;
    if (latest == null) return;

    switch (result) {
      case Success(:final value):
        state = AsyncData(
          latest.copyWith(
            items: [...latest.items, ...value.items],
            total: value.total,
            offset: latest.offset + value.items.length,
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

  /// Повторяет неудавшуюся дозагрузку.
  Future<void> retryLoadMore() => loadMore();

  /// Pull-to-refresh: перечитать журнал с начала (сбросив накопленные страницы).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(plantId));
  }

  /// Записать событие [eventType] (POST). Оптимистично вставляет результат в
  /// начало списка и инвалидирует «последние» провайдер для карточки растения.
  ///
  /// Возвращает `null` при успехе либо [ApiError] при неудаче (UI решает, какой
  /// тост показать — в т.ч. дедуп `ConflictError`). Список при ошибке не трогаем.
  Future<ApiError?> addEvent(PlantEventType eventType) async {
    final result =
        await ref.read(plantEventRepositoryProvider).addEvent(plantId, eventType);
    if (!ref.mounted) return null;

    switch (result) {
      case Success(:final value):
        final current = state.value;
        if (current != null) {
          state = AsyncData(
            current.copyWith(
              items: [value, ...current.items],
              total: current.total + 1,
              offset: current.offset + 1,
            ),
          );
        }
        ref.invalidate(recentPlantEventsProvider(plantId));
        return null;
      case Failure(:final error):
        return error;
    }
  }

  /// Запрос страницы через репозиторий; `Failure` пробрасывается как бросок
  /// [ApiError] — Riverpod упакует его в `AsyncError` для ПЕРВИЧНОЙ загрузки.
  Future<PlantEventsPage> _fetchPage({required int offset}) async {
    final result = await ref
        .read(plantEventRepositoryProvider)
        .getEvents(plantId, limit: _pageSize, offset: offset);
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }
}

/// Последние события для секции в карточке растения (02). Лёгкий read-only
/// провайдер: грузит первую страницу и отдаёт первые [_recentLimit] событий.
@riverpod
Future<List<PlantEvent>> recentPlantEvents(Ref ref, int plantId) async {
  final result = await ref
      .watch(plantEventRepositoryProvider)
      .getEvents(plantId, limit: _recentLimit, offset: 0);
  return switch (result) {
    Success(:final value) => value.items,
    Failure(:final error) => throw error,
  };
}
