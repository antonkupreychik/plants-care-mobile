import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/home_repository_provider.dart';
import '../domain/care_task.dart';
import '../domain/garden_location.dart';
import '../domain/plant.dart';

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

/// Задачи на сегодня (`GET /today`). Группировку «утро/вечер» делает UI
/// по `CareTask.dueAt` (в TZ пользователя) — domain интервалы не считает.
@riverpod
Future<List<CareTask>> homeTasks(Ref ref) async {
  final result = await ref.watch(homeRepositoryProvider).getTodayTasks();
  return _unwrap(result);
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
