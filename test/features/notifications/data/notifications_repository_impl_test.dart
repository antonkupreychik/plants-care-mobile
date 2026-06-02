import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/notifications_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/notification_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/notification_dto_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/notifications_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/notifications/data/notifications_repository_impl.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_type.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockNotificationsClient extends Mock implements NotificationsClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/notifications'),
      error: error,
    );

NotificationDto _dto(
  int id, {
  NotificationDtoType type = NotificationDtoType.care,
  DateTime? readAt,
}) =>
    NotificationDto(
      id: id,
      type: type,
      title: 'Заголовок $id',
      body: 'Тело $id',
      createdAt: DateTime.utc(2026, 6, 1, 9),
      readAt: readAt,
      plantId: 42,
    );

void main() {
  late _MockApi api;
  late _MockNotificationsClient client;
  late NotificationsRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockNotificationsClient();
    when(() => api.notifications).thenReturn(client);
    repo = NotificationsRepositoryImpl(api);
  });

  group('getFeed', () {
    test('should_map_items_to_domain_and_carry_unreadCount', () async {
      when(() => client.listNotifications(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => NotificationsResponse(
          items: [
            _dto(1, type: NotificationDtoType.alert),
            _dto(2, readAt: DateTime.utc(2026, 6, 1, 10)),
          ],
          unreadCount: 5,
        ),
      );

      final feed = (await repo.getFeed() as Success).value;

      expect(feed.items, hasLength(2));
      expect(feed.items.first.id, 1);
      expect(feed.items.first.type, NotificationType.alert);
      expect(feed.items.first.isRead, isFalse);
      expect(feed.items[1].isRead, isTrue);
      expect(feed.unreadCount, 5);
    });

    test('should_forward_limit_and_offset_to_client', () async {
      when(() => client.listNotifications(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const NotificationsResponse(items: [], unreadCount: 0),
      );

      await repo.getFeed(limit: 33, offset: 60);

      verify(() => client.listNotifications(
            limit: 33,
            offset: 60,
            extras: any(named: 'extras'),
          )).called(1);
    });

    // Auth-слот: лента ходит со scope user — `AuthInterceptor` подставит Bearer
    // из текущей AuthSession. Идентичность НЕ хардкодится в data-слое; этот
    // assert ловит молчаливую смену scope при подключении реального auth.
    test('should_send_user_authScope_in_extras', () async {
      when(() => client.listNotifications(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => const NotificationsResponse(items: [], unreadCount: 0),
      );

      await repo.getFeed();

      final captured = verify(() => client.listNotifications(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it',
        () async {
      when(() => client.listNotifications(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getFeed();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.listNotifications(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('boom'));

      final result = await repo.getFeed();

      // Наружу не бросаем — заворачиваем в Result.failure(unknown).
      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('markRead', () {
    test('should_call_client_with_given_id_and_return_success', () async {
      when(() => client.markNotificationRead(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      final result = await repo.markRead(77);

      expect(result, isA<Success<void>>());
      verify(() => client.markNotificationRead(
            id: 77,
            extras: any(named: 'extras'),
          )).called(1);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.markNotificationRead(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async {});

      await repo.markRead(77);

      final captured = verify(() => client.markNotificationRead(
            id: any(named: 'id'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_notFound_when_DioException_carries_it',
        () async {
      when(() => client.markNotificationRead(
            id: any(named: 'id'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.markRead(404);

      expect((result as Failure).error, const ApiError.notFound());
    });
  });
}
