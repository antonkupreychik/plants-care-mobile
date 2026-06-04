import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/shopping_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_list_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/shopping/data/shopping_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockShoppingClient extends Mock implements ShoppingClient {}

class _FakeCreateRequest extends Fake implements ShoppingItemCreateRequest {}

class _FakeUpdateRequest extends Fake implements ShoppingItemUpdateRequest {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/shopping'),
      error: error,
    );

ShoppingItemDto _dto(
  int id, {
  String title = 'Грунт',
  bool checked = false,
  DateTime? createdAt,
}) =>
    ShoppingItemDto(
      id: id,
      title: title,
      checked: checked,
      createdAt: createdAt,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeCreateRequest());
    registerFallbackValue(_FakeUpdateRequest());
  });

  late _MockApi api;
  late _MockShoppingClient client;
  late ShoppingRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockShoppingClient();
    when(() => api.shopping).thenReturn(client);
    repo = ShoppingRepositoryImpl(api);
  });

  group('listItems', () {
    test('should_map_response_items_to_domain', () async {
      when(() => client.listShoppingItems(extras: any(named: 'extras')))
          .thenAnswer(
        (_) async => ShoppingListResponse(
          items: [
            _dto(1, title: 'Грунт'),
            _dto(2, title: 'Горшок', checked: true),
          ],
        ),
      );

      final items = (await repo.listItems() as Success).value;

      expect(items, hasLength(2));
      expect(items.first.id, 1);
      expect(items.first.title, 'Грунт');
      expect(items.first.checked, isFalse);
      expect(items[1].checked, isTrue);
    });

    // Auth-слот: список ходит со scope user — `AuthInterceptor` подставит Bearer
    // из текущей AuthSession. Идентичность НЕ хардкодится в data-слое; assert
    // ловит молчаливую смену scope при подключении реального auth.
    test('should_send_user_authScope_in_extras', () async {
      when(() => client.listShoppingItems(extras: any(named: 'extras')))
          .thenAnswer((_) async => const ShoppingListResponse(items: []));

      await repo.listItems();

      final captured = verify(
        () => client.listShoppingItems(extras: captureAny(named: 'extras')),
      ).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => client.listShoppingItems(extras: any(named: 'extras')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.listItems();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.listShoppingItems(extras: any(named: 'extras')))
          .thenThrow(_dioWith('boom'));

      final result = await repo.listItems();

      // Наружу не бросаем — заворачиваем в Result.failure(unknown).
      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('addItem', () {
    test('should_send_title_in_create_request_and_map_result', () async {
      when(() => client.createShoppingItem(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _dto(10, title: 'Удобрение'));

      final item = (await repo.addItem('Удобрение') as Success).value;

      expect(item.id, 10);
      expect(item.title, 'Удобрение');
      final body = verify(() => client.createShoppingItem(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as ShoppingItemCreateRequest;
      expect(body.title, 'Удобрение');
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.createShoppingItem(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _dto(10));

      await repo.addItem('Грунт');

      final captured = verify(() => client.createShoppingItem(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_badRequest_when_DioException_carries_it',
        () async {
      when(() => client.createShoppingItem(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest()));

      final result = await repo.addItem('');

      expect((result as Failure).error, const ApiError.badRequest());
    });
  });

  group('setChecked', () {
    test('should_patch_only_checked_field_without_title', () async {
      when(() => client.updateShoppingItem(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _dto(5, checked: true));

      final item =
          (await repo.setChecked(id: 5, checked: true) as Success).value;

      expect(item.id, 5);
      expect(item.checked, isTrue);
      final body = verify(() => client.updateShoppingItem(
            id: 5,
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as ShoppingItemUpdateRequest;
      // Тоггл шлёт только {checked}; title должен остаться null, иначе PATCH
      // затёр бы текст позиции на backend.
      expect(body.checked, isTrue);
      expect(body.title, isNull);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.updateShoppingItem(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _dto(5, checked: true));

      await repo.setChecked(id: 5, checked: true);

      final captured = verify(() => client.updateShoppingItem(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => client.updateShoppingItem(
            id: any(named: 'id'),
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.setChecked(id: 404, checked: true);

      expect((result as Failure).error, const ApiError.notFound());
    });
  });

  group('deleteItem', () {
    test('should_call_client_with_given_id_and_return_success', () async {
      when(() => client.deleteShoppingItem(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result = await repo.deleteItem(77);

      expect(result, isA<Success<void>>());
      verify(() => client.deleteShoppingItem(
            id: 77,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.deleteShoppingItem(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.deleteItem(77);

      final captured = verify(() => client.deleteShoppingItem(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => client.deleteShoppingItem(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.deleteItem(1);

      expect((result as Failure).error, const ApiError.network());
    });
  });
}
