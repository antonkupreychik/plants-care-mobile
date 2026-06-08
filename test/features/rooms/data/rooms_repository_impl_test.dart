import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/locations_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockLocationsClient extends Mock implements LocationsClient {}

class _MockPlantsClient extends Mock implements PlantsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/locations'),
      error: error,
    );

PlantDto _plant(int id) => PlantDto(id: id, name: 'p$id', archived: false);

PageResponsePlantDto _page(
  List<PlantDto> items, {
  required int total,
  required int offset,
  int limit = 100,
}) =>
    PageResponsePlantDto(
      items: items,
      total: total,
      offset: offset,
      limit: limit,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(const LocationCreateRequest(name: 'x'));
    registerFallbackValue(const LocationUpdateRequest());
    registerFallbackValue(const PlantUpdateRequest());
  });

  late _MockApi api;
  late _MockLocationsClient locations;
  late _MockPlantsClient plants;
  late RoomsRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    locations = _MockLocationsClient();
    plants = _MockPlantsClient();
    when(() => api.locations).thenReturn(locations);
    when(() => api.plants).thenReturn(plants);
    repo = RoomsRepositoryImpl(api);
  });

  group('getLocations', () {
    test('should_return_success_with_mapped_locations_when_client_returns_dtos',
        () async {
      when(() => locations.listLocations(
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const [
          LocationDto(
            id: 1,
            name: 'Кухня',
            defaultLocation: true,
            isActive: true,
            emoji: '🍳',
          ),
          LocationDto(
            id: 2,
            name: 'Балкон',
            defaultLocation: false,
            isActive: false,
          ),
        ],
      );

      final result = await repo.getLocations();

      final list = (result as Success).value;
      expect(list, hasLength(2));
      expect(list.first.name, 'Кухня');
      expect(list.first.isDefault, isTrue);
      expect(list.first.emoji, '🍳');
      expect(list.last.isDefault, isFalse);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.listLocations(
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const []);

      await repo.getLocations();

      final captured = verify(() => locations.listLocations(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it', () async {
      when(() => locations.listLocations(
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getLocations();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => locations.listLocations(
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string'));

      final result = await repo.getLocations();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('createLocation', () {
    test('should_return_success_with_mapped_dto_and_pass_name_and_emoji',
        () async {
      when(() => locations.createLocation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async =>
            const LocationDto(
              id: 9,
              name: 'Спальня',
              defaultLocation: false,
              isActive: false,
              emoji: '🛏️',
            ),
      );

      final result = await repo.createLocation(name: 'Спальня', emoji: '🛏️');

      final loc = (result as Success).value;
      expect(loc.id, 9);
      expect(loc.name, 'Спальня');
      expect(loc.emoji, '🛏️');

      final body = verify(() => locations.createLocation(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as LocationCreateRequest;
      expect(body.name, 'Спальня');
      expect(body.emoji, '🛏️');
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.createLocation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const LocationDto(
              id: 1,
              name: 'x',
              defaultLocation: false,
              isActive: false,
            ),
      );

      await repo.createLocation(name: 'x');

      final captured = verify(() => locations.createLocation(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_badRequest_when_name_collides', () async {
      when(() => locations.createLocation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest(message: 'duplicate')));

      final result = await repo.createLocation(name: 'Кухня');

      expect((result as Failure).error,
          const ApiError.badRequest(message: 'duplicate'));
    });
  });

  group('updateLocation', () {
    test('should_return_success_and_pass_only_given_fields', () async {
      when(() => locations.updateLocation(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async =>
            const LocationDto(
              id: 3,
              name: 'Кабинет',
              defaultLocation: false,
              isActive: false,
            ),
      );

      final result = await repo.updateLocation(id: 3, name: 'Кабинет');

      expect((result as Success).value.name, 'Кабинет');

      final captured = verify(() => locations.updateLocation(
            id: captureAny(named: 'id'),
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured;
      expect(captured[0], 3);
      final body = captured[1] as LocationUpdateRequest;
      expect(body.name, 'Кабинет');
      // emoji не передан → null (PATCH-семантика «не менять»).
      expect(body.emoji, isNull);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.updateLocation(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const LocationDto(
              id: 3,
              name: 'x',
              defaultLocation: false,
              isActive: false,
            ),
      );

      await repo.updateLocation(id: 3, name: 'x');

      final captured = verify(() => locations.updateLocation(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => locations.updateLocation(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.updateLocation(id: 99, name: 'x');

      expect((result as Failure).error, const ApiError.notFound());
    });
  });

  group('deleteLocation', () {
    test('should_return_success_when_client_completes', () async {
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result = await repo.deleteLocation(id: 5);

      expect(result, isA<Success<void>>());
    });

    test('should_not_forward_targetLocationId_to_client', () async {
      // Issue #250: backend убрал каскадный перенос — targetLocationId в запрос
      // не уходит, даже если передан в репозиторий (оставлен для совместимости).
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteLocation(id: 5, targetLocationId: 7);

      final captured = verify(() => locations.deleteLocation(
            id: captureAny(named: 'id'),
            extras: any(named: 'extras'),
          )).captured;
      expect(captured.single, 5);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteLocation(id: 5);

      final captured = verify(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_locationNotEmpty_when_backend_rejects_delete',
        () async {
      // Спец-кейс LOCATION_NOT_EMPTY (теперь 409): ErrorInterceptor положил
      // типизированную ошибку — репозиторий обязан вернуть именно её.
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.locationNotEmpty()));

      final result = await repo.deleteLocation(id: 5);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<LocationNotEmptyError>());
    });
  });

  group('movePlantsAndDelete', () {
    test(
        'should_page_through_plants_move_each_then_delete_location_on_success',
        () async {
      // Локация #5 содержит 3 растения, разложенных по двум страницам
      // (limit=100): первая отдаёт [1,2], вторая [3]. Проверяем пагинацию.
      when(() => plants.listPlants(
            locationId: 5,
            offset: 0,
            limit: 100,
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => _page([_plant(1), _plant(2)], total: 3, offset: 0),
      );
      when(() => plants.listPlants(
            locationId: 5,
            offset: 2,
            limit: 100,
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _page([_plant(3)], total: 3, offset: 2));
      when(() => plants.updatePlant(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(0));
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result =
          await repo.movePlantsAndDelete(fromLocationId: 5, targetLocationId: 9);

      expect(result, isA<Success<void>>());
      // Каждое из 3 растений перенесено в target=9 (PATCH locationId).
      for (final id in [1, 2, 3]) {
        final body = verify(() => plants.updatePlant(
              id: id,
              body: captureAny(named: 'body'),
              extras: any(named: 'extras'),
            )).captured.single as PlantUpdateRequest;
        expect(body.locationId, 9);
      }
      // Только после переноса всех — удаление исходной локации.
      verify(() => locations.deleteLocation(
            id: 5,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('should_send_user_authScope_in_extras_for_list_update_and_delete',
        () async {
      when(() => plants.listPlants(
            locationId: any(named: 'locationId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _page([_plant(1)], total: 1, offset: 0));
      when(() => plants.updatePlant(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(0));
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.movePlantsAndDelete(fromLocationId: 5, targetLocationId: 9);

      final listExtras = verify(() => plants.listPlants(
            locationId: any(named: 'locationId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(listExtras[kAuthScopeExtraKey], AuthScope.user);

      final updateExtras = verify(() => plants.updatePlant(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(updateExtras[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_delete_location_directly_when_no_plants', () async {
      when(() => plants.listPlants(
            locationId: any(named: 'locationId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _page([], total: 0, offset: 0));
      when(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result =
          await repo.movePlantsAndDelete(fromLocationId: 5, targetLocationId: 9);

      expect(result, isA<Success<void>>());
      verifyNever(() => plants.updatePlant(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          ));
      verify(() => locations.deleteLocation(
            id: 5,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test(
        'should_not_delete_location_and_return_failure_when_a_plant_move_fails',
        () async {
      // 2 растения; перенос второго падает → локацию НЕ удаляем, Failure.
      when(() => plants.listPlants(
            locationId: any(named: 'locationId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => _page([_plant(1), _plant(2)], total: 2, offset: 0),
      );
      when(() => plants.updatePlant(
            id: 1,
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _plant(1));
      when(() => plants.updatePlant(
            id: 2,
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result =
          await repo.movePlantsAndDelete(fromLocationId: 5, targetLocationId: 9);

      expect((result as Failure).error, const ApiError.network());
      // Удаление локации НЕ вызвано — данные/непустую комнату не теряем.
      verifyNever(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          ));
    });

    test('should_return_failure_when_listing_plants_fails', () async {
      when(() => plants.listPlants(
            locationId: any(named: 'locationId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result =
          await repo.movePlantsAndDelete(fromLocationId: 5, targetLocationId: 9);

      expect((result as Failure).error, const ApiError.network());
      verifyNever(() => locations.deleteLocation(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          ));
    });
  });
}
