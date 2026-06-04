import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/network/connectivity_provider.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/home/presentation/home_view_state.dart';

const _plant = Plant(id: 1, name: 'Фикус');

typedef _PlantsBuild = Future<List<Plant>> Function();

/// Никогда не завершающийся Future → провайдер сада навсегда в loading.
Future<T> _pending<T>() => Completer<T>().future;

/// Контейнер с overridden [homePlantsProvider]; подписка удерживает
/// AutoDispose-провайдеры живыми между фазами.
ProviderContainer _container(_PlantsBuild build) {
  final container = ProviderContainer(
    overrides: [homePlantsProvider.overrideWith((ref) => build())],
  );
  addTearDown(container.dispose);
  final sub = container.listen(homeViewStateProvider, (_, _) {});
  addTearDown(sub.close);
  return container;
}

/// Прокручивает микротаски, пока сад не получит value (для success-сценариев).
Future<void> _untilHasValue(ProviderContainer container) async {
  for (var i = 0; i < 50; i++) {
    if (container.read(homePlantsProvider).hasValue) return;
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  // Деривация homeViewState из AsyncValue<List<Plant>> homePlantsProvider.
  // Чистые offline / non-network-без-кэша состояния (терминальный AsyncError)
  // проверяются на уровне виджета в home_screen_test — там цикл pump доводит
  // ошибку до осевшей фазы, чего ProviderContainer в одиночку не делает.
  group('homeViewStateProvider derivation', () {
    test('should_be_coldLoading_when_loading_without_value', () {
      final container = _container(_pending<List<Plant>>);

      // Чистый loading без значения → полноэкранный скелетон (28).
      expect(
        container.read(homeViewStateProvider),
        HomeViewState.coldLoading,
      );
    });

    test('should_be_content_when_data_present', () async {
      final container = _container(() async => const [_plant]);

      await _untilHasValue(container);

      expect(container.read(homeViewStateProvider), HomeViewState.content);
    });

    test('should_be_content_when_empty_data', () async {
      // Пустой сад — это валидные данные (GardenEmpty внутри), не coldLoading.
      final container = _container(() async => const <Plant>[]);

      await _untilHasValue(container);

      expect(container.read(homeViewStateProvider), HomeViewState.content);
    });

    test('should_be_content_not_coldLoading_when_loading_over_cache',
        () async {
      var fail = false;
      final container = _container(() async {
        if (fail) return _pending<List<Plant>>();
        return const [_plant];
      });
      await _untilHasValue(container);
      expect(container.read(homeViewStateProvider), HomeViewState.content);

      // Рефреш поверх кэша: фаза loading, прошлое value сохраняется → content.
      fail = true;
      container.invalidate(homePlantsProvider);
      final refreshing = container.read(homePlantsProvider);

      expect(refreshing.isLoading, isTrue);
      expect(refreshing.hasValue, isTrue);
      expect(container.read(homeViewStateProvider), HomeViewState.content);
    });

    test('should_be_content_when_error_over_cache', () async {
      // Кэш есть; затем ошибка при рефреше → НЕ полноэкранный офлайн (content).
      var fail = false;
      final container = _container(() async {
        if (fail) throw const ApiError.network();
        return const [_plant];
      });
      await _untilHasValue(container);

      fail = true;
      container.invalidate(homePlantsProvider);
      // value удерживается поверх ошибки независимо от фазы isLoading.
      final after = container.read(homePlantsProvider);

      expect(after.hasValue, isTrue);
      expect(container.read(homeViewStateProvider), HomeViewState.content);
    });
  });

  // Дискриминатор полноэкранный офлайн (29) vs посекционный ErrorState:
  // именно по нему ветвится правило offline в homeViewState.
  group('isNetworkError extension', () {
    test('should_be_true_for_NetworkError', () {
      expect(const ApiError.network().isNetworkError, isTrue);
    });

    test('should_be_false_for_other_ApiError', () {
      expect(const ApiError.unknown().isNetworkError, isFalse);
      expect(const ApiError.notFound().isNetworkError, isFalse);
      expect(const ApiError.accessDenied().isNetworkError, isFalse);
    });

    test('should_be_false_for_non_ApiError_and_null', () {
      expect(Exception('x').isNetworkError, isFalse);
      expect(null.isNetworkError, isFalse);
    });
  });

  // Авто-рефетч при восстановлении сети: homeViewState подписан на
  // connectivityProvider и инвалидирует home-провайдеры при переходе false→true.
  group('connectivity auto-refetch', () {
    test(
        'should_invalidate_home_plants_when_connectivity_transitions_offline_to_online',
        () async {
      // Расставляем управляемый стрим для connectivity.
      final connectivityController = StreamController<bool>();
      addTearDown(connectivityController.close);

      // plants: сначала network error, затем вернём данные после инвалидации.
      var plantsCallCount = 0;
      final container = ProviderContainer(
        overrides: [
          connectivityProvider.overrideWith(
            (_) => connectivityController.stream,
          ),
          homePlantsProvider.overrideWith((ref) async {
            plantsCallCount++;
            if (plantsCallCount == 1) throw const ApiError.network();
            return const [_plant];
          }),
        ],
      );
      addTearDown(container.dispose);

      // Подписка держит провайдеры живыми.
      final sub = container.listen(homeViewStateProvider, (prev, next) {});
      addTearDown(sub.close);

      // Ждём, пока plants осядут в AsyncError.
      for (var i = 0; i < 100; i++) {
        await Future<void>.delayed(Duration.zero);
        final plants = container.read(homePlantsProvider);
        if (plants.hasError && !plants.isLoading) break;
      }
      // plants должны быть в NetworkError без кэша.
      final plants = container.read(homePlantsProvider);
      expect(plants.hasError, isTrue, reason: 'homePlantsProvider должен быть в ошибке');
      expect(plants.error, isA<ApiError>().having(
        (e) => e.isNetworkError, 'isNetworkError', isTrue,
      ));

      final callsBefore = plantsCallCount;

      // Имитируем offline → online переход через стрим.
      connectivityController.add(false); // offline
      await Future<void>.delayed(Duration.zero);
      connectivityController.add(true); // online restored
      // Даём несколько тиков для обработки callback.
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(Duration.zero);
      }

      // homeViewState должен был инвалидировать homePlantsProvider.
      expect(plantsCallCount, greaterThan(callsBefore));
    });

    test(
        'should_not_invalidate_when_connectivity_stays_online',
        () async {
      final connectivityController = StreamController<bool>();
      addTearDown(connectivityController.close);

      var plantsCallCount = 0;
      final container = ProviderContainer(
        overrides: [
          connectivityProvider.overrideWith(
            (_) => connectivityController.stream,
          ),
          homePlantsProvider.overrideWith((ref) async {
            plantsCallCount++;
            return const [_plant];
          }),
        ],
      );
      addTearDown(container.dispose);

      final sub = container.listen(homeViewStateProvider, (prev, next) {});
      addTearDown(sub.close);

      // Ждём загрузки данных.
      for (var i = 0; i < 50; i++) {
        if (container.read(homePlantsProvider).hasValue) break;
        await Future<void>.delayed(Duration.zero);
      }
      final callsAfterLoad = plantsCallCount;

      // Оба события «true» (online → online) → инвалидации нет.
      connectivityController.add(true);
      await Future<void>.delayed(Duration.zero);
      connectivityController.add(true);
      await Future<void>.delayed(Duration.zero);

      // Провайдер не инвалидировался (звонков больше не стало).
      expect(plantsCallCount, equals(callsAfterLoad));
    });
  });
}
