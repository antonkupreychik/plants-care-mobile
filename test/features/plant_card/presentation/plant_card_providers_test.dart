import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_card_repository.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';

class _MockRepo extends Mock implements PlantCardRepository {}

const _plantId = 42;

ProviderContainer _containerWith(PlantCardRepository repo) {
  final container = ProviderContainer(
    overrides: [plantCardRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписывается на family-провайдер и ждёт перехода в ошибку. Подписка
/// (а не `.future`) удерживает AutoDispose-провайдер живым (как в home_providers_test).
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

  group('plantDetailProvider', () {
    test('should_emit_data_when_repository_succeeds', () async {
      const plant = Plant(id: _plantId, name: 'Фикус');
      when(() => repo.getPlant(_plantId))
          .thenAnswer((_) async => const Result.success(plant));
      final container = _containerWith(repo);

      final value = await container.read(plantDetailProvider(_plantId).future);

      expect(value, plant);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(() => repo.getPlant(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.notFound()));
      final container = _containerWith(repo);

      final error = await _awaitError<Plant>(
        container,
        (listener) => container.listen(plantDetailProvider(_plantId), listener),
      );

      expect(error, const ApiError.notFound());
    });
  });

  group('plantHistoryProvider', () {
    test('should_emit_data_when_repository_succeeds', () async {
      final entry = CareHistoryEntry(
        id: 1,
        plantId: _plantId,
        plantName: 'Фикус',
        kind: CareEventKind.water,
        performedAt: DateTime.utc(2026, 5, 27, 8),
        onTime: true,
      );
      when(() => repo.getHistory(_plantId))
          .thenAnswer((_) async => Result.success([entry]));
      final container = _containerWith(repo);

      final value =
          await container.read(plantHistoryProvider(_plantId).future);

      expect(value, [entry]);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(() => repo.getHistory(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final error = await _awaitError<List<CareHistoryEntry>>(
        container,
        (listener) =>
            container.listen(plantHistoryProvider(_plantId), listener),
      );

      expect(error, const ApiError.network());
    });
  });

  group('plantStreakProvider', () {
    test('should_emit_data_when_repository_succeeds', () async {
      const streak = Streak(plantId: _plantId, count: 5);
      when(() => repo.getStreak(_plantId))
          .thenAnswer((_) async => const Result.success(streak));
      final container = _containerWith(repo);

      final value = await container.read(plantStreakProvider(_plantId).future);

      expect(value, streak);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(() => repo.getStreak(_plantId)).thenAnswer(
          (_) async => const Result.failure(ApiError.accessDenied()));
      final container = _containerWith(repo);

      final error = await _awaitError<Streak>(
        container,
        (listener) => container.listen(plantStreakProvider(_plantId), listener),
      );

      expect(error, const ApiError.accessDenied());
    });
  });
}
