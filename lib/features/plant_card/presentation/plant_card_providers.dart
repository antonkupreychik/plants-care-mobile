import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../data/plant_card_repository_provider.dart';
import '../domain/care_history_entry.dart';
import '../domain/plant_health.dart';
import '../domain/streak.dart';

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
/// `plantHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
/// (README §5 / FLUTTER.md «Правила state»).

/// Деталь растения (`GET /plants/{id}`, scope user).
@riverpod
Future<Plant> plantDetail(Ref ref, int plantId) async {
  final result = await ref.watch(plantCardRepositoryProvider).getPlant(plantId);
  return _unwrap(result);
}

/// История ухода (`GET /plants/{id}/history?limit=10`, scope chat).
/// Записи приходят отсортированными backend; клиент порядок не меняет.
@riverpod
Future<List<CareHistoryEntry>> plantHistory(Ref ref, int plantId) async {
  final result =
      await ref.watch(plantCardRepositoryProvider).getHistory(plantId);
  return _unwrap(result);
}

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

/// Разворачивает `Result<T>`: успех → значение, ошибка → бросок [ApiError],
/// который Riverpod упакует в `AsyncError` (типизированный, не строка).
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      Failure<T>(:final error) => throw error,
    };
