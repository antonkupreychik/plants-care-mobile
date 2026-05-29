import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
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
}
