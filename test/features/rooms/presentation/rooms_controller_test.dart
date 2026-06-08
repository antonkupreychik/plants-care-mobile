import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_repository.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_screen_layout.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_repository_provider.dart';
import 'package:plantcare_mobile/core/sdui/presentation/screen_layout_provider.dart';
import 'package:plantcare_mobile/features/home/data/home_repository_provider.dart';
import 'package:plantcare_mobile/features/home/domain/home_repository.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_provider.dart';
import 'package:plantcare_mobile/features/rooms/domain/rooms_repository.dart';
import 'package:plantcare_mobile/features/rooms/presentation/rooms_controller.dart';

class _MockRoomsRepo extends Mock implements RoomsRepository {}

class _MockHomeRepo extends Mock implements HomeRepository {}

class _MockSduiRepo extends Mock implements SduiRepository {}

const _kitchen = GardenLocation(id: 1, name: 'Кухня', isDefault: true);
const _balcony = GardenLocation(id: 2, name: 'Балкон', isDefault: false);

const _layout = SduiScreenLayout(screenId: 'home', version: 1, blocks: []);

ProviderContainer _container(
  _MockRoomsRepo repo, {
  HomeRepository? homeRepo,
  SduiRepository? sduiRepo,
}) {
  final container = ProviderContainer(
    overrides: [
      roomsRepositoryProvider.overrideWithValue(repo),
      if (homeRepo != null) homeRepositoryProvider.overrideWithValue(homeRepo),
      if (sduiRepo != null) sduiRepositoryProvider.overrideWithValue(sduiRepo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late _MockRoomsRepo repo;

  setUp(() => repo = _MockRoomsRepo());

  group('initial load', () {
    test('should_expose_list_when_repo_returns_success', () async {
      when(repo.getLocations).thenAnswer(
        (_) async => const Result.success([_kitchen, _balcony]),
      );
      final container = _container(repo);

      final list = await container.read(roomsControllerProvider.future);

      expect(list, [_kitchen, _balcony]);
    });

    test('should_expose_AsyncError_with_ApiError_when_repo_fails', () async {
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      // Постоянная подписка держит autoDispose-провайдер живым на время
      // загрузки (иначе диспоузится до эмита ошибки) и копит переходы.
      final states = <AsyncValue<List<GardenLocation>>>[];
      final sub = container.listen(
        roomsControllerProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);
      expect(states.first.isLoading, isTrue);

      // Дожидаемся, пока build (async repo) переведёт состояние в error.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(roomsControllerProvider);
      expect(state.hasError, isTrue);
      // build развернул Failure броском ApiError → тот же тип в AsyncError.
      expect(state.error, const ApiError.network());
    });
  });

  group('create', () {
    test('should_return_success_and_refetch_list', () async {
      var calls = 0;
      when(repo.getLocations).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.success([_kitchen])
            : const Result.success([_kitchen, _balcony]);
      });
      when(() => repo.createLocation(
            name: any(named: 'name'),
            emoji: any(named: 'emoji'),
          )).thenAnswer((_) async => const Result.success(_balcony));
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result =
          await container.read(roomsControllerProvider.notifier).create(name: 'Балкон');

      expect(result, isA<Success<GardenLocation>>());
      expect((result as Success).value, _balcony);
      // Список перечитан → теперь две комнаты.
      expect(container.read(roomsControllerProvider).value, [_kitchen, _balcony]);
      verify(repo.getLocations).called(2);
    });

    test('should_return_failure_and_not_refetch_when_repo_fails', () async {
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen]));
      when(() => repo.createLocation(
            name: any(named: 'name'),
            emoji: any(named: 'emoji'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.badRequest(message: 'dup')),
      );
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result =
          await container.read(roomsControllerProvider.notifier).create(name: 'Кухня');

      expect(result, isA<Failure<GardenLocation>>());
      // Список не перечитан (getLocations всего 1 раз — начальная загрузка).
      verify(repo.getLocations).called(1);
    });
  });

  group('rename', () {
    test('should_return_success_and_refetch_list', () async {
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen]));
      when(() => repo.updateLocation(
            id: any(named: 'id'),
            name: any(named: 'name'),
            emoji: any(named: 'emoji'),
          )).thenAnswer(
        (_) async => const Result.success(
          GardenLocation(id: 2, name: 'Лоджия', isDefault: false),
        ),
      );
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result = await container
          .read(roomsControllerProvider.notifier)
          .rename(id: 2, name: 'Лоджия');

      expect((result as Success).value.name, 'Лоджия');
      verify(repo.getLocations).called(2);
    });
  });

  group('delete', () {
    test('should_return_success_and_refetch_list', () async {
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.deleteLocation(
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.success(null));
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result =
          await container.read(roomsControllerProvider.notifier).delete(id: 2);

      expect(result, isA<Success<void>>());
      verify(repo.getLocations).called(2);
    });

    test(
        'should_return_failure_locationNotEmpty_and_keep_list_intact_when_not_empty',
        () async {
      // Удаление непустой комнаты без target → Failure(LocationNotEmptyError).
      // Список НЕ должен упасть/перечитаться: UI на этой ошибке показывает
      // пикер переноса и повторяет delete с targetLocationId.
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.deleteLocation(
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.failure(ApiError.locationNotEmpty()));
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result =
          await container.read(roomsControllerProvider.notifier).delete(id: 2);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<LocationNotEmptyError>());
      // Список цел: две комнаты, без ошибки/loading.
      final state = container.read(roomsControllerProvider);
      expect(state.hasError, isFalse);
      expect(state.value, [_kitchen, _balcony]);
      // Только начальная загрузка — рефетча не было (мутация неуспешна).
      verify(repo.getLocations).called(1);
    });

    test('should_pass_targetLocationId_on_retry_delete', () async {
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.deleteLocation(
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.success(null));
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      await container
          .read(roomsControllerProvider.notifier)
          .delete(id: 2, targetLocationId: 1);

      verify(() => repo.deleteLocation(id: 2, targetLocationId: 1)).called(1);
    });
  });

  group('moveAndDelete', () {
    test('should_return_success_and_refetch_list', () async {
      var calls = 0;
      when(repo.getLocations).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.success([_kitchen, _balcony])
            : const Result.success([_kitchen]);
      });
      when(() => repo.movePlantsAndDelete(
            fromLocationId: any(named: 'fromLocationId'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.success(null));
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result = await container
          .read(roomsControllerProvider.notifier)
          .moveAndDelete(id: 2, targetLocationId: 1);

      expect(result, isA<Success<void>>());
      verify(() => repo.movePlantsAndDelete(
            fromLocationId: 2,
            targetLocationId: 1,
          )).called(1);
      // Список перечитан → осталась одна комната.
      expect(container.read(roomsControllerProvider).value, [_kitchen]);
      verify(repo.getLocations).called(2);
    });

    test('should_return_failure_and_not_refetch_when_move_fails', () async {
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.movePlantsAndDelete(
            fromLocationId: any(named: 'fromLocationId'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);
      await container.read(roomsControllerProvider.future);

      final result = await container
          .read(roomsControllerProvider.notifier)
          .moveAndDelete(id: 2, targetLocationId: 1);

      expect(result, isA<Failure<void>>());
      // Список не перечитан (мутация неуспешна) и остался цел.
      final state = container.read(roomsControllerProvider);
      expect(state.value, [_kitchen, _balcony]);
      verify(repo.getLocations).called(1);
    });
  });

  group('home invalidation after mutation', () {
    test('should_refetch_homeLocations_after_successful_create', () async {
      // homeLocationsProvider ходит через homeRepository.getLocations(). После
      // успешной мутации контроллер инвалидирует его → повторный fetch.
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen]));
      when(() => repo.createLocation(
            name: any(named: 'name'),
            emoji: any(named: 'emoji'),
          )).thenAnswer((_) async => const Result.success(_balcony));

      final homeRepo = _MockHomeRepo();
      when(homeRepo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen]));

      final container = _container(repo, homeRepo: homeRepo);
      // Держим подписку на home-локации, иначе autoDispose их выкинет и
      // invalidate просто удалит провайдер, а не перечитает.
      final sub = container.listen(homeLocationsProvider, (_, _) {});
      addTearDown(sub.close);

      await container.read(roomsControllerProvider.future);
      await container.read(homeLocationsProvider.future);
      verify(homeRepo.getLocations).called(1);

      await container
          .read(roomsControllerProvider.notifier)
          .create(name: 'Балкон');
      await container.read(homeLocationsProvider.future);

      // Инвалидация сработала → home-локации перечитаны.
      verify(homeRepo.getLocations).called(1);
    });

    test('should_rebuild_home_sdui_layout_after_successful_delete', () async {
      // Регрессия #193: Home watch'ит homeScreenLayoutProvider (SDUI-витрина).
      // После успешного delete контроллер инвалидирует его → сервер пересобирает
      // лейаут (повторный getHomeLayout). Без фикса витрина висела старой.
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.deleteLocation(
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.success(null));

      final sduiRepo = _MockSduiRepo();
      when(sduiRepo.getHomeLayout)
          .thenAnswer((_) async => const Result.success(_layout));

      final container = _container(repo, sduiRepo: sduiRepo);
      // Подписка держит autoDispose-провайдер живым, иначе invalidate его просто
      // выкинет, а не перечитает.
      final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
      addTearDown(sub.close);

      await container.read(roomsControllerProvider.future);
      await container.read(homeScreenLayoutProvider.future);
      verify(sduiRepo.getHomeLayout).called(1);

      await container.read(roomsControllerProvider.notifier).delete(id: 2);
      await container.read(homeScreenLayoutProvider.future);

      // Инвалидация сработала → SDUI-лейаут пересобран.
      verify(sduiRepo.getHomeLayout).called(1);
    });

    test('should_rebuild_home_sdui_layout_after_successful_moveAndDelete',
        () async {
      // Тот же канал инвалидации для каскадного move+delete (issue #183).
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.movePlantsAndDelete(
            fromLocationId: any(named: 'fromLocationId'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer((_) async => const Result.success(null));

      final sduiRepo = _MockSduiRepo();
      when(sduiRepo.getHomeLayout)
          .thenAnswer((_) async => const Result.success(_layout));

      final container = _container(repo, sduiRepo: sduiRepo);
      final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
      addTearDown(sub.close);

      await container.read(roomsControllerProvider.future);
      await container.read(homeScreenLayoutProvider.future);
      verify(sduiRepo.getHomeLayout).called(1);

      await container
          .read(roomsControllerProvider.notifier)
          .moveAndDelete(id: 2, targetLocationId: 1);
      await container.read(homeScreenLayoutProvider.future);

      verify(sduiRepo.getHomeLayout).called(1);
    });

    test('should_not_rebuild_home_sdui_layout_when_delete_fails', () async {
      // Негатив: неуспешная мутация не инвалидирует SDUI-витрину.
      when(repo.getLocations)
          .thenAnswer((_) async => const Result.success([_kitchen, _balcony]));
      when(() => repo.deleteLocation(
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.locationNotEmpty()),
      );

      final sduiRepo = _MockSduiRepo();
      when(sduiRepo.getHomeLayout)
          .thenAnswer((_) async => const Result.success(_layout));

      final container = _container(repo, sduiRepo: sduiRepo);
      final sub = container.listen(homeScreenLayoutProvider, (_, _) {});
      addTearDown(sub.close);

      await container.read(roomsControllerProvider.future);
      await container.read(homeScreenLayoutProvider.future);
      verify(sduiRepo.getHomeLayout).called(1);

      await container.read(roomsControllerProvider.notifier).delete(id: 2);
      await container.read(homeScreenLayoutProvider.future);

      // Мутация неуспешна → инвалидации не было, повторного fetch нет.
      verifyNever(sduiRepo.getHomeLayout);
    });
  });
}
