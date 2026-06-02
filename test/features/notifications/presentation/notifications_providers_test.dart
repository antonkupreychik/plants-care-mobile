import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/notifications/data/notifications_repository_provider.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_feed.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_item.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_type.dart';
import 'package:plantcare_mobile/features/notifications/domain/notifications_repository.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_providers.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_state.dart';

class _MockRepo extends Mock implements NotificationsRepository {}

NotificationItem _item(int id, {bool read = false}) => NotificationItem(
      id: id,
      type: NotificationType.care,
      title: 'Заголовок $id',
      body: 'Тело $id',
      createdAt: DateTime.utc(2026, 6, 1, 9),
      readAt: read ? DateTime.utc(2026, 6, 1, 10) : null,
    );

NotificationFeed _feed(List<NotificationItem> items, {required int unread}) =>
    NotificationFeed(items: items, unreadCount: unread);

ProviderContainer _containerWith(NotificationsRepository repo) {
  final container = ProviderContainer(
    overrides: [notificationsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписка удерживает autoDispose-провайдер живым между чтениями.
void _keepAlive(ProviderContainer container) {
  final sub = container.listen(notificationsControllerProvider, (_, _) {});
  addTearDown(sub.close);
}

NotificationsState _state(ProviderContainer c) =>
    c.read(notificationsControllerProvider).value!;

/// Подписывается на провайдер и ждёт первого перехода в ошибку (подписка
/// удерживает autoDispose-провайдер живым), как в care_history_providers_test.
Future<Object?> _awaitError(ProviderContainer container) {
  final completer = Completer<Object?>();
  final sub = container.listen(notificationsControllerProvider, (_, next) {
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

  group('initial build', () {
    test('should_load_first_page_and_expose_unreadCount', () async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _feed([_item(1), _item(2)], unread: 2),
        ),
      );
      final container = _containerWith(repo);

      final state =
          await container.read(notificationsControllerProvider.future);

      expect(state.items.map((e) => e.id), [1, 2]);
      expect(state.unreadCount, 2);
      expect(state.lastPageSize, 2);
      expect(container.read(unreadCountProvider), 2);
      verify(() => repo.getFeed(limit: 20, offset: 0)).called(1);
    });

    test('should_throw_ApiError_into_AsyncError_when_first_page_fails',
        () async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final error = await _awaitError(container);

      expect(error, const ApiError.network());
      // unreadCount остаётся 0, пока лента в ошибке (badge не показывается).
      expect(container.read(unreadCountProvider), 0);
    });
  });

  group('markRead optimistic', () {
    test('should_mark_read_and_decrement_unreadCount_before_network_answers',
        () async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(_feed([_item(1), _item(2)], unread: 2)),
      );
      // markRead зависает — проверяем состояние ДО ответа сети.
      final pending = Completer<Result<void>>();
      when(() => repo.markRead(1)).thenAnswer((_) => pending.future);
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      final future =
          container.read(notificationsControllerProvider.notifier).markRead(1);

      // Оптимистично, ещё до завершения сети.
      final optimistic = _state(container);
      expect(optimistic.items.firstWhere((e) => e.id == 1).isRead, isTrue);
      expect(optimistic.unreadCount, 1);
      expect(container.read(unreadCountProvider), 1);

      pending.complete(const Result.success(null));
      await future;

      // Успех — состояние не откатывается.
      expect(_state(container).items.firstWhere((e) => e.id == 1).isRead,
          isTrue);
      expect(_state(container).unreadCount, 1);
    });

    test('should_rollback_isRead_and_unreadCount_when_network_fails', () async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(_feed([_item(1), _item(2)], unread: 2)),
      );
      when(() => repo.markRead(1))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .markRead(1);

      // Откат: isRead снова false, счётчик восстановлен.
      final after = _state(container);
      expect(after.items.firstWhere((e) => e.id == 1).isRead, isFalse);
      expect(after.unreadCount, 2);
      expect(container.read(unreadCountProvider), 2);
    });

    test('should_be_noop_for_already_read_item', () async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async =>
            Result.success(_feed([_item(1, read: true)], unread: 0)),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .markRead(1);

      // Уже прочитано → ни запроса, ни декремента (не уходим в минус).
      verifyNever(() => repo.markRead(any()));
      expect(_state(container).unreadCount, 0);
    });
  });

  group('markAllRead', () {
    test('should_mark_all_unread_read_and_request_only_unread_ids', () async {
      // Лента: 1 и 3 непрочитаны, 2 уже прочитан.
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _feed([_item(1), _item(2, read: true), _item(3)], unread: 2),
        ),
      );
      when(() => repo.markRead(any()))
          .thenAnswer((_) async => const Result.success(null));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .markAllRead();

      final after = _state(container);
      expect(after.items.every((e) => e.isRead), isTrue);
      expect(after.unreadCount, 0);
      expect(container.read(unreadCountProvider), 0);
      // Запрос ушёл ровно по непрочитанным id, по 1 разу каждому.
      verify(() => repo.markRead(1)).called(1);
      verify(() => repo.markRead(3)).called(1);
      // Идемпотентность: по уже прочитанному id запроса нет.
      verifyNever(() => repo.markRead(2));
    });

    test('should_reconcile_via_refresh_when_one_markRead_fails', () async {
      var feedCalls = 0;
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async {
        feedCalls++;
        if (feedCalls == 1) {
          // Первая загрузка: 1 и 2 непрочитаны.
          return Result.success(_feed([_item(1), _item(2)], unread: 2));
        }
        // Реконсиляция через refresh(): backend говорит, что прочитан только 1,
        // а 2 остался непрочитанным (его markRead не приняли).
        return Result.success(
          _feed([_item(1, read: true), _item(2)], unread: 1),
        );
      });
      // id=2 → Failure, id=1 → Success: один из батча не принят backend.
      when(() => repo.markRead(1))
          .thenAnswer((_) async => const Result.success(null));
      when(() => repo.markRead(2))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .markAllRead();

      // Состояние пришло из backend (refresh), а НЕ из локального оптимизма:
      // оптимистично было бы unreadCount==0 и оба isRead; backend вернул иное.
      final after = _state(container);
      expect(after.items.firstWhere((e) => e.id == 1).isRead, isTrue);
      expect(after.items.firstWhere((e) => e.id == 2).isRead, isFalse);
      expect(after.unreadCount, 1);
      expect(container.read(unreadCountProvider), 1);
      // Реконсиляция произошла: getFeed перечитан повторно (build + refresh).
      verify(() => repo.getFeed(limit: 20, offset: 0)).called(2);
    });

    test('should_be_noop_when_no_unread_items', () async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _feed([_item(1, read: true), _item(2, read: true)], unread: 0),
        ),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      final before = _state(container);
      await container
          .read(notificationsControllerProvider.notifier)
          .markAllRead();

      // Непрочитанных нет → ни markRead, ни повторного getFeed (refresh).
      verifyNever(() => repo.markRead(any()));
      verify(() => repo.getFeed(limit: 20, offset: 0)).called(1);
      // Состояние не изменилось.
      expect(identical(_state(container), before), isTrue);
      expect(_state(container).unreadCount, 0);
    });
  });

  group('loadMore', () {
    test('should_append_next_page_and_advance_offset', () async {
      when(() => repo.getFeed(limit: 20, offset: 0)).thenAnswer(
        (_) async => Result.success(
          _feed(List.generate(20, (i) => _item(i + 1)), unread: 20),
        ),
      );
      when(() => repo.getFeed(limit: 20, offset: 20)).thenAnswer(
        (_) async => Result.success(_feed([_item(21), _item(22)], unread: 18)),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .loadMore();

      final state = _state(container);
      expect(state.items, hasLength(22));
      expect(state.items.last.id, 22);
      // Свежий счётчик со второй страницы.
      expect(state.unreadCount, 18);
      expect(state.isLoadingMore, isFalse);
      verify(() => repo.getFeed(limit: 20, offset: 20)).called(1);
    });

    test('should_be_noop_when_last_page_was_incomplete', () async {
      when(() => repo.getFeed(limit: 20, offset: 0)).thenAnswer(
        (_) async => Result.success(_feed([_item(1), _item(2)], unread: 2)),
      );
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .loadMore();

      // 2 < 20 → конец ленты, дозагрузки нет.
      verify(() => repo.getFeed(limit: 20, offset: 0)).called(1);
      verifyNever(() => repo.getFeed(limit: 20, offset: 2));
    });

    test('should_not_start_second_loadMore_while_one_in_flight', () async {
      when(() => repo.getFeed(limit: 20, offset: 0)).thenAnswer(
        (_) async => Result.success(
          _feed(List.generate(20, (i) => _item(i + 1)), unread: 20),
        ),
      );
      final pending = Completer<Result<NotificationFeed>>();
      when(() => repo.getFeed(limit: 20, offset: 20))
          .thenAnswer((_) => pending.future);
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      final notifier =
          container.read(notificationsControllerProvider.notifier);

      final first = notifier.loadMore();
      await notifier.loadMore(); // вторая — no-op (isLoadingMore)

      expect(_state(container).isLoadingMore, isTrue);

      pending.complete(
        Result.success(_feed([_item(21)], unread: 19)),
      );
      await first;

      verify(() => repo.getFeed(limit: 20, offset: 20)).called(1);
    });

    test('should_set_loadMoreError_keep_list_then_recover_on_retry', () async {
      when(() => repo.getFeed(limit: 20, offset: 0)).thenAnswer(
        (_) async => Result.success(
          _feed(List.generate(20, (i) => _item(i + 1)), unread: 20),
        ),
      );
      var calls = 0;
      when(() => repo.getFeed(limit: 20, offset: 20)).thenAnswer((_) async {
        calls++;
        if (calls == 1) return const Result.failure(ApiError.network());
        return Result.success(_feed([_item(21), _item(22)], unread: 18));
      });
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .loadMore();

      // Ошибка дозагрузки: список сохранён, провайдер НЕ в AsyncError.
      var after = container.read(notificationsControllerProvider);
      expect(after.hasError, isFalse);
      expect(after.value!.items, hasLength(20));
      expect(after.value!.loadMoreError, const ApiError.network());
      expect(after.value!.isLoadingMore, isFalse);

      // retryLoadMore → успех, страница дозагружена, ошибка снята.
      await container
          .read(notificationsControllerProvider.notifier)
          .retryLoadMore();

      after = container.read(notificationsControllerProvider);
      expect(after.value!.items, hasLength(22));
      expect(after.value!.loadMoreError, isNull);
    });
  });

  group('refresh', () {
    test('should_reload_first_page_from_scratch', () async {
      var calls = 0;
      when(() => repo.getFeed(limit: 20, offset: 0)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          return Result.success(_feed([_item(1)], unread: 1));
        }
        return Result.success(_feed([_item(9), _item(10)], unread: 0));
      });
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(notificationsControllerProvider.future);
      await container
          .read(notificationsControllerProvider.notifier)
          .refresh();

      final state = _state(container);
      expect(state.items.map((e) => e.id), [9, 10]);
      expect(state.unreadCount, 0);
      verify(() => repo.getFeed(limit: 20, offset: 0)).called(2);
    });
  });
}
