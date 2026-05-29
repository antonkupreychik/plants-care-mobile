import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/domain/streak.dart';
import '../data/care_history_repository_provider.dart';
import '../domain/care_history_page.dart';
import '../domain/care_history_summary.dart';
import 'care_history_state.dart';

part 'care_history_providers.g.dart';

/// State-слой экрана «Полная история ухода» (21).
///
/// Четыре family-провайдера (по `plantId`), а не один агрегат: таймлайн,
/// сводка, деталь растения и стрик грузятся и падают независимо — UI рисует
/// skeleton/ошибку посекционно (как на экране 02, `plant_card_providers`).
///
/// Контракт для ui-builder:
/// - [careHistoryControllerProvider] — `AsyncValue<CareHistoryState>`
///   (loading / error / data). В `AsyncError` лежит типизированный [ApiError].
///   Из `data` UI читает `state.visibleEntries`, `state.total`,
///   `state.hasMore`, `state.isLoadingMore`, `state.filter`.
///   Методы контроллера: `loadMore()`, `setFilter(CareEventKind?)`.
/// - [careHistorySummaryProvider] — `CareHistorySummary?` (sync, выводится из
///   состояния контроллера + стрика; `null` пока нет данных истории).
/// - [careHistoryPlantProvider] — `AsyncValue<Plant>` (имя в шапку +
///   `createdAt` для маркера появления растения).
/// - [careHistoryStreakProvider] — `AsyncValue<Streak>`.
///
/// После `POST /care-events` для этого растения инвалидируй
/// `careHistoryControllerProvider(plantId)` и `careHistoryStreakProvider(plantId)`
/// (README §5 / FLUTTER.md «Правила state»).

/// Размер первичной и последующих страниц.
///
/// 50 — баланс: для типичного растения покрывает всю историю одной страницей
/// (сводка и таймлайн полные сразу), для активных есть [CareHistoryController.loadMore].
/// Backend требует `limit ∈ [1, 100]`.
const int _pageSize = 50;

/// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
///
/// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
/// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
/// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
/// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).
@riverpod
class CareHistoryController extends _$CareHistoryController {
  @override
  Future<CareHistoryState> build(int plantId) async {
    final page = await _fetchPage(offset: 0);
    return CareHistoryState(
      entries: page.items,
      total: page.total,
      offset: page.items.length,
    );
  }

  /// Подгрузить следующую страницу и аппендить к накопленным.
  ///
  /// No-op, если данных ещё нет (идёт первичная загрузка/ошибка), уже грузится
  /// или больше нечего грузить. Ошибку страницы кладёт в
  /// [CareHistoryState.loadMoreError] (показанный список сохраняется), а не в
  /// `AsyncError` всего провайдера — как в `CatalogController.loadMore`.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final result = await ref
        .read(careHistoryRepositoryProvider)
        .getHistoryPage(plantId, limit: _pageSize, offset: current.offset);

    // Нотифаер autoDispose — мог быть утилизирован за время await.
    if (!ref.mounted) return;

    // Аккумулируем от свежеперечитанного состояния, а не от захваченного
    // `current`: за время await фильтр мог смениться в рамках того же plantId.
    final latest = state.value;
    if (latest == null) return;

    switch (result) {
      case Success(:final value):
        state = AsyncData(
          latest.copyWith(
            entries: [...latest.entries, ...value.items],
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

  /// Повторяет неудавшуюся дозагрузку (`loadMoreError` → попытка снова).
  Future<void> retryLoadMore() => loadMore();

  /// Переключить клиентский фильтр по типу ухода (`null` — все).
  /// Не дёргает сеть: фильтрует уже загруженные записи (`state.visibleEntries`).
  void setFilter(CareEventKind? kind) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(filter: kind));
  }

  /// Запрос страницы через репозиторий; `Result.failure` пробрасывается как
  /// бросок `ApiError` — Riverpod упакует его в `AsyncError` для ПЕРВИЧНОЙ
  /// загрузки (`build`). Для дозагрузки ошибки идут в `loadMoreError`.
  Future<CareHistoryPage> _fetchPage({required int offset}) async {
    final result = await ref
        .read(careHistoryRepositoryProvider)
        .getHistoryPage(plantId, limit: _pageSize, offset: offset);
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }
}

/// Сводка для шапки (всего / вовремя% / стрик), выведенная из накопленного
/// состояния контроллера и стрика. `null`, пока история ещё грузится/ошибка.
///
/// `onTimePercent` считается по ЗАГРУЖЕННЫМ записям (`loadedCount`), не по
/// `total` — серверного агрегата нет (BACKEND-GAPS G29).
@riverpod
CareHistorySummary? careHistorySummary(Ref ref, int plantId) {
  final history = ref.watch(careHistoryControllerProvider(plantId)).value;
  if (history == null) return null;

  // Стрик независим: если он не догрузился/упал — показываем 0, сводка по
  // истории остаётся полезной (секции падают независимо).
  final streak = ref.watch(careHistoryStreakProvider(plantId)).value;

  return CareHistorySummary(
    total: history.total,
    onTimeCount: history.entries.where((e) => e.onTime).length,
    loadedCount: history.entries.length,
    streakCount: streak?.count ?? 0,
  );
}

/// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
/// `createdAt` (маркер появления растения в таймлайне).
@riverpod
Future<Plant> careHistoryPlant(Ref ref, int plantId) async {
  final result =
      await ref.watch(careHistoryRepositoryProvider).getPlant(plantId);
  return _unwrap(result);
}

/// Стрик растения (`GET /stats/streak`, scope chat).
@riverpod
Future<Streak> careHistoryStreak(Ref ref, int plantId) async {
  final result =
      await ref.watch(careHistoryRepositoryProvider).getStreak(plantId);
  return _unwrap(result);
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
