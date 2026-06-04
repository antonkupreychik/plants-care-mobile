import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/offline_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/notifications/data/notifications_repository_provider.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_feed.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_item.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_type.dart';
import 'package:plantcare_mobile/features/notifications/domain/notifications_repository.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_screen.dart';
import 'package:plantcare_mobile/features/notifications/presentation/widgets/notification_card.dart';
import 'package:plantcare_mobile/features/notifications/presentation/widgets/notifications_empty.dart';
import 'package:plantcare_mobile/features/notifications/presentation/widgets/notifications_group_header.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements NotificationsRepository {}

Future<T> _pending<T>() => Completer<T>().future;

NotificationItem _item(
  int id, {
  bool read = false,
  DateTime? createdAt,
  NotificationType type = NotificationType.care,
}) =>
    NotificationItem(
      id: id,
      type: type,
      title: 'Заголовок $id',
      body: 'Тело $id',
      createdAt: createdAt ?? DateTime.utc(2026, 6, 1, 9),
      readAt: read ? DateTime.utc(2026, 6, 1, 10) : null,
    );

NotificationFeed _feed(List<NotificationItem> items, {required int unread}) =>
    NotificationFeed(items: items, unreadCount: unread);

void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _wrap(NotificationsRepository repo) => ProviderScope(
      overrides: [notificationsRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const NotificationsScreen(),
      ),
    );

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(NotificationsScreen)));

void main() {
  setUpAll(() => registerFallbackValue(StackTrace.empty));

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  void stubFeed(Result<NotificationFeed> result) {
    when(() => repo.getFeed(
            limit: any(named: 'limit'), offset: any(named: 'offset')))
        .thenAnswer((_) async => result);
  }

  group('states', () {
    testWidgets('should_show_skeleton_when_loading', (tester) async {
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) => _pending<Result<NotificationFeed>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(NotificationCard), findsNothing);
    });

    testWidgets('should_show_offline_state_when_NetworkError', (tester) async {
      stubFeed(const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // NetworkError → полноэкранный OfflineState (экран 29), не ErrorState.
      expect(find.byType(OfflineState), findsOneWidget);
      expect(find.byType(ErrorState), findsNothing);
    });

    testWidgets('should_show_errorState_with_retry_for_non_network_error',
        (tester) async {
      stubFeed(const Result.failure(ApiError.accessDenied()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.byType(OfflineState), findsNothing);
      expect(find.text(_l10n(tester).retry), findsOneWidget);
    });

    testWidgets('should_recover_to_data_when_error_retry_tapped',
        (tester) async {
      _tallSurface(tester);
      // Сеть восстанавливается между показом ошибки и нажатием retry: пока
      // ошибка — fail, после переключаем на success. Авто-петли перезапроса в
      // состоянии ошибки нет (retry только ручной по тапу), поэтому используем
      // флаг healed, а не счётчик вызовов: тест проверяет восстановление до
      // data после починки сети, а не точное число обращений к getFeed.
      var healed = false;
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async {
        if (!healed) return const Result.failure(ApiError.accessDenied());
        return Result.success(_feed([_item(1)], unread: 1));
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);

      healed = true;
      await tester.tap(find.text(_l10n(tester).retry));
      await tester.pumpAndSettle();

      // refresh() перечитал ленту → данные показаны, ошибки нет.
      expect(find.byType(ErrorState), findsNothing);
      expect(find.byType(NotificationCard), findsOneWidget);
    });

    testWidgets('should_show_empty_screen32_when_feed_empty', (tester) async {
      stubFeed(Result.success(_feed(const [], unread: 0)));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationsEmpty), findsOneWidget);
      expect(find.byType(NotificationCard), findsNothing);
    });

    testWidgets('should_render_cards_when_data', (tester) async {
      _tallSurface(tester);
      stubFeed(
        Result.success(
          _feed([_item(1), _item(2, read: true), _item(3)], unread: 2),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationCard), findsNWidgets(3));
      expect(find.byType(NotificationsEmpty), findsNothing);
    });
  });

  group('mark read interaction', () {
    testWidgets('should_call_markRead_when_unread_card_tapped', (tester) async {
      _tallSurface(tester);
      stubFeed(Result.success(_feed([_item(1)], unread: 1)));
      when(() => repo.markRead(1))
          .thenAnswer((_) async => const Result.success(null));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NotificationCard).first);
      await tester.pumpAndSettle();

      verify(() => repo.markRead(1)).called(1);
    });

    testWidgets('should_not_call_markRead_when_read_card_tapped',
        (tester) async {
      _tallSurface(tester);
      stubFeed(Result.success(_feed([_item(1, read: true)], unread: 0)));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Прочитанная карточка не интерактивна — InkWell внутри неё не вешается.
      expect(
        find.descendant(
          of: find.byType(NotificationCard),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      await tester.tap(find.byType(NotificationCard).first, warnIfMissed: false);
      await tester.pumpAndSettle();

      verifyNever(() => repo.markRead(any()));
    });
  });

  // КЛЮЧЕВОЙ регрессионный тест: группировка по дням считается из
  // createdAt.toLocal(), а НЕ по UTC. Строим UTC-инстант, который при переводе в
  // локаль перепрыгивает границу суток — он обязан попасть в группу по локальному дню.
  // Тест пропускается на UTC-раннере (offset == 0): граница суток в UTC совпадает
  // с локальной, поэтому проверить рассинхрон технически невозможно без инжекта TZ.
  group('day grouping with non-UTC timezone', () {
    final systemOffset = DateTime.now().timeZoneOffset;
    testWidgets(
      'should_group_boundary_item_by_LOCAL_day_not_utc',
      // Пропускаем под UTC: offset==0, UTC==local, граница суток не пересекается.
      // Под TZ=America/Los_Angeles или TZ=Asia/... тест активен.
      skip: systemOffset == Duration.zero,
      (tester) async {
        _tallSurface(tester);

        final localOffset = systemOffset;

        // Берём «сегодня» по локали и строим UTC-инстант, который при переводе в
        // локаль остаётся внутри СЕГОДНЯ, но его UTC-календарный день другой.
        final nowLocal = DateTime.now();
        final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);

        // Локальный момент у границы суток (00:30 при +TZ / 23:30 при -TZ), так
        // что соответствующий UTC попадёт на соседний календарный день.
        final boundaryLocal = localOffset > Duration.zero
            ? today.add(const Duration(minutes: 30)) // сегодня 00:30 local
            : today.add(const Duration(hours: 23, minutes: 30)); // сегодня 23:30
        final boundaryUtc = boundaryLocal.toUtc();

        // Sanity: UTC-день инстанта ОТЛИЧАЕТСЯ от локального — иначе тест ничего
        // не доказывает.
        final boundaryUtcDay = DateTime(
          boundaryUtc.year,
          boundaryUtc.month,
          boundaryUtc.day,
        );
        final boundaryLocalDay = DateTime(
          boundaryLocal.year,
          boundaryLocal.month,
          boundaryLocal.day,
        );
        expect(
          boundaryUtcDay,
          isNot(boundaryLocalDay),
          reason: 'Инстант должен пересекать границу суток для текущей TZ.',
        );

        stubFeed(
          Result.success(
            _feed([_item(1, createdAt: boundaryUtc)], unread: 1),
          ),
        );

        await tester.pumpWidget(_wrap(repo));
        await tester.pumpAndSettle();

        // По локальному дню запись — «Сегодня». Если бы группировка шла по UTC,
        // запись попала бы во «Вчера»/дату (другой календарный день).
        final headers = tester
            .widgetList<NotificationsGroupHeader>(
              find.byType(NotificationsGroupHeader),
            )
            .toList();
        expect(headers, hasLength(1));
        expect(
          headers.single.label,
          _l10n(tester).notificationsGroupToday,
          reason: 'Группа считается по createdAt.toLocal(), не по UTC.',
        );
      },
    );
  });

  group('pull to refresh on empty', () {
    testWidgets('should_reload_feed_on_pull_to_refresh', (tester) async {
      var calls = 0;
      when(() => repo.getFeed(
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async {
        calls++;
        if (calls == 1) return Result.success(_feed(const [], unread: 0));
        return Result.success(_feed([_item(1)], unread: 1));
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationsEmpty), findsOneWidget);

      // Pull-to-refresh жестом по прокручиваемой пустой ленте.
      await tester.fling(
        find.byType(ListView),
        const Offset(0, 400),
        1000,
      );
      await tester.pumpAndSettle();

      verify(() => repo.getFeed(limit: 20, offset: 0)).called(2);
      expect(find.byType(NotificationCard), findsOneWidget);
    });
  });
}
