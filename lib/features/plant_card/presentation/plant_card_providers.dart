import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../../home/presentation/home_providers.dart';
import '../data/plant_card_repository_provider.dart';
import '../domain/care_history_entry.dart';
import '../domain/plant_health.dart';
import '../domain/streak.dart';
import 'plant_card_history_state.dart';

part 'plant_card_providers.g.dart';

/// State-слой экрана «Карточка растения» (02).
///
/// Три независимых family-провайдера (по `plantId`), а не один агрегат: деталь,
/// история и стрик грузятся и падают независимо — UI рисует skeleton/ошибку
/// посекционно (например, стрик дал 404, а деталь и история готовы). Так же
/// устроен экран 01 (`home_providers.dart`), повторяем паттерн 1:1.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
///
/// После `POST /care-events` для этого растения инвалидируй
/// `plantCardHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
/// (README §5 / FLUTTER.md «Правила state»).

/// Размер первой и последующих страниц дневника на карточке.
const int _kPageSize = 5;

/// Деталь растения (`GET /plants/{id}`, scope user).
@riverpod
Future<Plant> plantDetail(Ref ref, int plantId) async {
  final result = await ref.watch(plantCardRepositoryProvider).getPlant(plantId);
  return _unwrap(result);
}

/// История ухода для карточки — первые 5 записей без пагинации.
///
/// Используется для инвалидации после `POST /care-events` (LOG_CARE_EVENT_CONTROLLER)
/// и как запасной провайдер в тестах, не переведённых на [plantCardHistoryProvider].
/// Новый UI использует [plantCardHistoryProvider].
@riverpod
Future<List<CareHistoryEntry>> plantHistory(Ref ref, int plantId) async {
  final result =
      await ref.watch(plantCardRepositoryProvider).getHistory(plantId);
  return _unwrap(result);
}

/// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
///
/// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
/// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
///
/// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
/// — нотифаер перезагрузится с нуля (первые 5).
@riverpod
class PlantCardHistory extends _$PlantCardHistory {
  @override
  Future<PlantCardHistoryState> build(int plantId) async {
    final page = await _fetchPage(offset: 0);
    return PlantCardHistoryState(
      items: page.items,
      total: page.total,
      offset: page.items.length,
    );
  }

  /// Подгрузить следующую страницу и аппендить к уже показанным.
  ///
  /// No-op если данных ещё нет / грузится / нечего грузить.
  /// Ошибку дозагрузки кладёт в [PlantCardHistoryState.loadMoreError]
  /// (показанный список сохраняется), а не в `AsyncError` всего провайдера.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final result = await ref
        .read(plantCardRepositoryProvider)
        .getHistoryPage(plantId, limit: _kPageSize, offset: current.offset);

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

  Future<_PageResult> _fetchPage({required int offset}) async {
    final result = await ref
        .read(plantCardRepositoryProvider)
        .getHistoryPage(plantId, limit: _kPageSize, offset: offset);
    return switch (result) {
      Success(:final value) => (items: value.items, total: value.total),
      Failure(:final error) => throw error,
    };
  }
}

typedef _PageResult = ({List<CareHistoryEntry> items, int total});

/// Стрик растения (`GET /stats/streak`, scope chat).
@riverpod
Future<Streak> plantStreak(Ref ref, int plantId) async {
  final result =
      await ref.watch(plantCardRepositoryProvider).getStreak(plantId);
  return _unwrap(result);
}

/// Health Score растения (`GET /plants/{id}/health`, scope none — публичный).
///
/// Один family-провайдер на `plantId` для ОБОИХ потребителей: бейдж на карточке
/// растения (02) и кольцо на карточках Home-сетки (01, по `plant.id`). Family
/// кэширует по ключу и автодиспозит — два разных провайдера НЕ заводим.
@riverpod
Future<PlantHealth> plantHealth(Ref ref, int plantId) async {
  final result =
      await ref.watch(plantCardRepositoryProvider).getPlantHealth(plantId);
  return _unwrap(result);
}

/// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
///
/// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
/// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
/// чтобы домашний экран больше не показывал архивное растение.
/// UI должен слушать state и при [AsyncData] навигироваться на '/home'.
@riverpod
class ArchivePlant extends _$ArchivePlant {
  @override
  FutureOr<void> build(int plantId) => null;

  /// Запускает архивацию; повторный вызов в [AsyncLoading] игнорируется
  /// (защита от двойного тапа).
  Future<void> archive() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final result =
        await ref.read(plantCardRepositoryProvider).archivePlant(plantId);
    switch (result) {
      case Success<void>():
        ref.invalidate(plantDetailProvider(plantId));
        ref.invalidate(homePlantsProvider);
        state = const AsyncData(null);
      case Failure<void>(:final error):
        state = AsyncError(error, StackTrace.current);
    }
  }
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
