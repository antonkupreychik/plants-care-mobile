import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/home/data/home_repository_provider.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/features/home/domain/home_repository.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';

class _MockRepo extends Mock implements HomeRepository {}

ProviderContainer _containerWith(HomeRepository repo) {
  final container = ProviderContainer(
    overrides: [homeRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписывается на AsyncNotifier-провайдер и ждёт перехода в [AsyncError],
/// возвращая саму ошибку. Подписка (а не `.future`) удерживает
/// AutoDispose-провайдер живым, поэтому он не диспоузится в loading.
Future<Object?> _awaitError<T>(
  ProviderContainer container,
  ProviderSubscription<AsyncValue<T>> Function(
    void Function(AsyncValue<T>? prev, AsyncValue<T> next) listener,
  ) listen,
) {
  final completer = Completer<Object?>();
  late final ProviderSubscription<AsyncValue<T>> sub;
  sub = listen((_, next) {
    // Riverpod 3 во время неудачного rebuild эмитит AsyncLoading с прикреплённой
    // ошибкой → ловим по hasError, а не по типу AsyncError.
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

  group('homeTasksProvider', () {
    test('should_emit_data_when_repository_succeeds', () async {
      final task = CareTask(
        scheduleId: 1,
        plantId: 1,
        plantName: 'Monstera',
        type: CareTaskType.watering,
        dueAt: DateTime.utc(2026, 5, 27, 9),
      );
      when(repo.getTodayTasks)
          .thenAnswer((_) async => Result.success([task]));
      final container = _containerWith(repo);

      final value = await container.read(homeTasksProvider.future);

      expect(value, [task]);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(repo.getTodayTasks)
          .thenAnswer((_) async => const Result.failure(ApiError.notFound()));
      final container = _containerWith(repo);

      final error = await _awaitError<List<CareTask>>(
        container,
        (listener) => container.listen(homeTasksProvider, listener),
      );
      expect(error, const ApiError.notFound());
    });
  });

  group('homePlantsProvider', () {
    test('should_emit_data_when_repository_succeeds', () async {
      const plant = Plant(id: 1, name: 'Фикус');
      when(() => repo.getPlants())
          .thenAnswer((_) async => const Result.success([plant]));
      final container = _containerWith(repo);

      final value = await container.read(homePlantsProvider.future);

      expect(value, [plant]);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(() => repo.getPlants())
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final error = await _awaitError<List<Plant>>(
        container,
        (listener) => container.listen(homePlantsProvider, listener),
      );
      expect(error, const ApiError.network());
    });
  });

  group('homeLocationsProvider', () {
    test('should_emit_data_when_repository_succeeds', () async {
      const loc = GardenLocation(id: 1, name: 'Кухня', isDefault: true);
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([loc]));
      final container = _containerWith(repo);

      final value = await container.read(homeLocationsProvider.future);

      expect(value, [loc]);
    });

    test('should_throw_ApiError_into_AsyncError_when_repository_fails',
        () async {
      when(repo.getLocations).thenAnswer(
          (_) async => const Result.failure(ApiError.accessDenied()));
      final container = _containerWith(repo);

      final error = await _awaitError<List<GardenLocation>>(
        container,
        (listener) =>
            container.listen(homeLocationsProvider, listener),
      );
      expect(error, const ApiError.accessDenied());
    });
  });
}
