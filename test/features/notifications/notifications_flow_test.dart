import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/notifications_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/notification_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/notification_dto_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/notifications_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/notifications/data/notifications_repository_impl.dart';
import 'package:plantcare_mobile/features/notifications/data/notifications_repository_provider.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_providers.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_screen.dart';
import 'package:plantcare_mobile/features/notifications/presentation/widgets/notification_card.dart';
import 'package:plantcare_mobile/features/notifications/presentation/widgets/notifications_empty.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockNotificationsClient extends Mock implements NotificationsClient {}

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
      // Все «сегодня» по локали → одна группа, помещается в кадр.
      createdAt: DateTime.now().toUtc(),
      readAt: readAt,
      plantId: 42,
    );

void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUpAll(() => registerFallbackValue(StackTrace.empty));

  late _MockApi api;
  late _MockNotificationsClient client;

  setUp(() {
    api = _MockApi();
    client = _MockNotificationsClient();
    when(() => api.notifications).thenReturn(client);
  });

  // Реальный repo + контроллер + маппер поверх мок-клиента: полноценный флоу,
  // не подмена логики (как в care_history_flow_test).
  Widget app() => ProviderScope(
        overrides: [
          notificationsRepositoryProvider
              .overrideWithValue(NotificationsRepositoryImpl(api)),
        ],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const NotificationsScreen(),
        ),
      );

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(
        tester.element(find.byType(NotificationsScreen)),
      );

  testWidgets(
      'should_open_loading_then_data_and_mark_read_updates_count_and_badge',
      (tester) async {
    _tallSurface(tester);

    when(() => client.listNotifications(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: any(named: 'extras'),
        )).thenAnswer(
      (_) async => NotificationsResponse(
        items: [_dto(1), _dto(2)],
        unreadCount: 2,
      ),
    );
    when(() => client.markNotificationRead(
          id: any(named: 'id'),
          extras: any(named: 'extras'),
        )).thenAnswer((_) async {});

    // 1. Открытие → загрузка → данные.
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.byType(NotificationCard), findsNWidgets(2));

    final container = containerOf(tester);
    expect(container.read(unreadCountProvider), 2);

    // 2. Тап по непрочитанному → markRead, счётчик/badge уменьшились.
    await tester.tap(find.byType(NotificationCard).first);
    await tester.pumpAndSettle();

    expect(container.read(unreadCountProvider), 1);

    // Auth-слот: запросы фичи ушли со scope user (Bearer подставит интерсептор),
    // идентичность не хардкодится. Ловит молчаливую регрессию scope.
    final feedExtras = verify(() => client.listNotifications(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: captureAny(named: 'extras'),
        )).captured.cast<Map<String, dynamic>>();
    expect(feedExtras, isNotEmpty);
    expect(
      feedExtras.every((e) => e[kAuthScopeExtraKey] == AuthScope.user),
      isTrue,
    );
    // markRead ушёл по верному id со scope user.
    final markExtras = verify(() => client.markNotificationRead(
          id: 1,
          extras: captureAny(named: 'extras'),
        )).captured.single as Map<String, dynamic>;
    expect(markExtras[kAuthScopeExtraKey], AuthScope.user);
  });

  testWidgets('should_render_empty_screen32_and_refresh_via_pull',
      (tester) async {
    var calls = 0;
    when(() => client.listNotifications(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: any(named: 'extras'),
        )).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return const NotificationsResponse(items: [], unreadCount: 0);
      }
      return NotificationsResponse(items: [_dto(9)], unreadCount: 1);
    });

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // Пустой случай → экран 32.
    expect(find.byType(NotificationsEmpty), findsOneWidget);

    // Pull-to-refresh по прокручиваемой пустой ленте → перечитала, данные есть.
    await tester.fling(
      find.byType(ListView),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(find.byType(NotificationsEmpty), findsNothing);
    expect(find.byType(NotificationCard), findsOneWidget);
    verify(() => client.listNotifications(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: any(named: 'extras'),
        )).called(2);
  });

  testWidgets('should_keep_flow_working_when_network_error', (tester) async {
    when(() => client.listNotifications(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: any(named: 'extras'),
        )).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/notifications'),
        error: const ApiError.network(),
      ),
    );

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // Сеть упала → офлайн-состояние, не повисший экран и не падение.
    expect(find.byType(NotificationCard), findsNothing);
    expect(find.byType(NotificationsEmpty), findsNothing);
  });
}
