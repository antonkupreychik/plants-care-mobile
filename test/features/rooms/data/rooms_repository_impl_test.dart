import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/locations_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/location_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/rooms/data/rooms_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockLocationsClient extends Mock implements LocationsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/locations'),
      error: error,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(const LocationCreateRequest(name: 'x'));
    registerFallbackValue(const LocationUpdateRequest());
  });

  late _MockApi api;
  late _MockLocationsClient locations;
  late RoomsRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    locations = _MockLocationsClient();
    when(() => api.locations).thenReturn(locations);
    repo = RoomsRepositoryImpl(api);
  });

  group('getLocations', () {
    test('should_return_success_with_mapped_locations_when_client_returns_dtos',
        () async {
      when(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const [
          LocationDto(id: 1, name: 'Кухня', defaultLocation: true, emoji: '🍳'),
          LocationDto(id: 2, name: 'Балкон', defaultLocation: false),
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
            xUserId: any(named: 'xUserId'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const []);

      await repo.getLocations();

      final captured = verify(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it', () async {
      when(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getLocations();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => locations.listLocations(
            xUserId: any(named: 'xUserId'),
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
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async =>
            const LocationDto(id: 9, name: 'Спальня', defaultLocation: false, emoji: '🛏️'),
      );

      final result = await repo.createLocation(name: 'Спальня', emoji: '🛏️');

      final loc = (result as Success).value;
      expect(loc.id, 9);
      expect(loc.name, 'Спальня');
      expect(loc.emoji, '🛏️');

      final body = verify(() => locations.createLocation(
            xUserId: any(named: 'xUserId'),
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as LocationCreateRequest;
      expect(body.name, 'Спальня');
      expect(body.emoji, '🛏️');
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.createLocation(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const LocationDto(id: 1, name: 'x', defaultLocation: false),
      );

      await repo.createLocation(name: 'x');

      final captured = verify(() => locations.createLocation(
            xUserId: any(named: 'xUserId'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_badRequest_when_name_collides', () async {
      when(() => locations.createLocation(
            xUserId: any(named: 'xUserId'),
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
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async =>
            const LocationDto(id: 3, name: 'Кабинет', defaultLocation: false),
      );

      final result = await repo.updateLocation(id: 3, name: 'Кабинет');

      expect((result as Success).value.name, 'Кабинет');

      final captured = verify(() => locations.updateLocation(
            xUserId: any(named: 'xUserId'),
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
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const LocationDto(id: 3, name: 'x', defaultLocation: false),
      );

      await repo.updateLocation(id: 3, name: 'x');

      final captured = verify(() => locations.updateLocation(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => locations.updateLocation(
            xUserId: any(named: 'xUserId'),
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
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result = await repo.deleteLocation(id: 5);

      expect(result, isA<Success<void>>());
    });

    test('should_forward_targetLocationId_to_client', () async {
      when(() => locations.deleteLocation(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteLocation(id: 5, targetLocationId: 7);

      final captured = verify(() => locations.deleteLocation(
            xUserId: any(named: 'xUserId'),
            id: captureAny(named: 'id'),
            targetLocationId: captureAny(named: 'targetLocationId'),
            extras: any(named: 'extras'),
          )).captured;
      expect(captured[0], 5);
      expect(captured[1], 7);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => locations.deleteLocation(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteLocation(id: 5);

      final captured = verify(() => locations.deleteLocation(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_locationNotEmpty_when_backend_rejects_delete',
        () async {
      // Спец-кейс LOCATION_NOT_EMPTY: ErrorInterceptor положил типизированную
      // ошибку — репозиторий обязан вернуть именно её (UI на ней показывает
      // пикер переноса).
      when(() => locations.deleteLocation(
            xUserId: any(named: 'xUserId'),
            id: any(named: 'id'),
            targetLocationId: any(named: 'targetLocationId'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.locationNotEmpty()));

      final result = await repo.deleteLocation(id: 5);

      expect(result, isA<Failure<void>>());
      expect((result as Failure).error, isA<LocationNotEmptyError>());
    });
  });
}
