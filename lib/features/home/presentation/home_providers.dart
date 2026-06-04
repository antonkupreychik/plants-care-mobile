import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/care/care_task.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
import '../data/home_repository_provider.dart';
import '../domain/plant.dart';
import '../domain/today_tasks_result.dart';

part 'home_providers.g.dart';

/// State-слой экрана «Главная — Мой сад» (01).
///
/// Три независимых провайдера (today / plants / locations), а не один агрегат:
/// секции грузятся и падают независимо, UI рисует skeleton/ошибку посекционно
/// (например, задачи ещё грузятся, а список растений уже готов). Это проще
/// инвалидировать после `POST /care-events` (инвалидируем только `homeTasks`)
/// и тестировать. Если позже понадобится единый «заголовок саммари» — он
/// собирается из этих трёх на уровне UI/Notifier без перетряхивания data.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.

/// Задачи на сегодня со сводкой прогресса (`GET /today`).
///
/// Возвращает [TodayTasksResult] с полным списком задач (включая выполненные)
/// и счётчиками завершения из `TodaySummary` для прогресс-бара в [TodayCard].
/// Инвалидировать после `POST /care-events`.
@riverpod
Future<TodayTasksResult> homeTasks(Ref ref) async {
  final result = await ref.watch(homeRepositoryProvider).getTodayTasks();
  return _unwrap(result);
}

/// Плоский список задач на сегодня — производный от [homeTasksProvider].
///
/// Используется в [todayViewProvider] для деривации экрана 03 «Сегодня».
/// Не делает отдельного запроса к API — только извлекает поле из кешированного
/// [homeTasksProvider].
@riverpod
Future<List<CareTask>> homeTasksList(Ref ref) async {
  final result = await ref.watch(homeTasksProvider.future);
  return result.tasks;
}

/// Растения пользователя (`GET /plants`).
@riverpod
Future<List<Plant>> homePlants(Ref ref) async {
  final result = await ref.watch(homeRepositoryProvider).getPlants();
  return _unwrap(result);
}

/// Локации пользователя (`GET /locations`).
@riverpod
Future<List<GardenLocation>> homeLocations(Ref ref) async {
  final result = await ref.watch(homeRepositoryProvider).getLocations();
  return _unwrap(result);
}

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
