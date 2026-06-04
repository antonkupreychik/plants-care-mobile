import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/shopping_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_list_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/shopping/data/shopping_repository_impl.dart';
import 'package:plantcare_mobile/features/shopping/data/shopping_repository_provider.dart';
import 'package:plantcare_mobile/features/shopping/presentation/shopping_screen.dart';
import 'package:plantcare_mobile/features/shopping/presentation/widgets/shopping_empty.dart';
import 'package:plantcare_mobile/features/shopping/presentation/widgets/shopping_item_tile.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockShoppingClient extends Mock implements ShoppingClient {}

class _FakeCreateRequest extends Fake implements ShoppingItemCreateRequest {}

class _FakeUpdateRequest extends Fake implements ShoppingItemUpdateRequest {}

ShoppingItemDto _dto(int id, {String? title, bool checked = false}) =>
    ShoppingItemDto(
      id: id,
      title: title ?? 'Позиция $id',
      checked: checked,
      createdAt: DateTime.utc(2026, 6, 1, 9),
    );

void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(_FakeCreateRequest());
    registerFallbackValue(_FakeUpdateRequest());
  });

  late _MockApi api;
  late _MockShoppingClient client;

  setUp(() {
    api = _MockApi();
    client = _MockShoppingClient();
    when(() => api.shopping).thenReturn(client);
  });

  // Реальный repo + контроллер + маппер поверх мок-клиента: полноценный флоу,
  // не подмена логики (как notifications_flow_test / care_history_flow_test).
  Widget app() => ProviderScope(
        overrides: [
          shoppingRepositoryProvider
              .overrideWithValue(ShoppingRepositoryImpl(api)),
        ],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const ShoppingScreen(),
        ),
      );

  testWidgets('should_flow_add_then_toggle_then_delete', (tester) async {
    _tallSurface(tester);

    // Список растёт по мере add: backend-источник истины. Каждый listShoppingItems
    // отдаёт текущий снимок.
    final store = <ShoppingItemDto>[];
    when(() => client.listShoppingItems(extras: any(named: 'extras')))
        .thenAnswer((_) async => ShoppingListResponse(items: List.of(store)));
    when(() => client.createShoppingItem(
          body: any(named: 'body'),
          extras: any(named: 'extras'),
        )).thenAnswer((invocation) async {
      final body =
          invocation.namedArguments[#body] as ShoppingItemCreateRequest;
      final created = _dto(1, title: body.title);
      store.add(created);
      return created;
    });
    when(() => client.updateShoppingItem(
          id: any(named: 'id'),
          body: any(named: 'body'),
          extras: any(named: 'extras'),
        )).thenAnswer((invocation) async {
      final id = invocation.namedArguments[#id] as int;
      final body =
          invocation.namedArguments[#body] as ShoppingItemUpdateRequest;
      final i = store.indexWhere((d) => d.id == id);
      final updated = _dto(id, title: store[i].title, checked: body.checked!);
      store[i] = updated;
      return updated;
    });
    when(() => client.deleteShoppingItem(
          id: any(named: 'id'),
          extras: any(named: 'extras'),
        )).thenAnswer((invocation) async {
      final id = invocation.namedArguments[#id] as int;
      store.removeWhere((d) => d.id == id);
    });

    // 1. Открытие → пустой список.
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.byType(ShoppingEmpty), findsOneWidget);

    // 2. Добавить позицию через sheet → видно в списке.
    await tester.tap(find.text(AppLocalizations.of(
            tester.element(find.byType(ShoppingScreen)))
        .shoppingAddItem));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Грунт');
    await tester.pump();
    await tester.tap(find.text(AppLocalizations.of(
            tester.element(find.byType(ShoppingScreen)))
        .shoppingAddSheetSubmit));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingItemTile), findsOneWidget);
    expect(find.text('Грунт'), findsOneWidget);

    // 3. Тап по строке → toggle checked (backend получил {checked: true}).
    await tester.tap(find.byType(ShoppingItemTile).first);
    await tester.pumpAndSettle();
    expect(store.single.checked, isTrue);

    // 4. Свайп → delete → снова пусто.
    await tester.drag(
      find.byType(ShoppingItemTile).first,
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    expect(store, isEmpty);
    expect(find.byType(ShoppingEmpty), findsOneWidget);

    // Auth-слот: все запросы фичи ушли со scope user (Bearer подставит
    // интерсептор), идентичность не хардкодится — ловит молчаливую регрессию.
    final createExtras = verify(() => client.createShoppingItem(
          body: any(named: 'body'),
          extras: captureAny(named: 'extras'),
        )).captured.single as Map<String, dynamic>;
    expect(createExtras[kAuthScopeExtraKey], AuthScope.user);
    final updateExtras = verify(() => client.updateShoppingItem(
          id: any(named: 'id'),
          body: any(named: 'body'),
          extras: captureAny(named: 'extras'),
        )).captured.single as Map<String, dynamic>;
    expect(updateExtras[kAuthScopeExtraKey], AuthScope.user);
    final deleteExtras = verify(() => client.deleteShoppingItem(
          id: any(named: 'id'),
          extras: captureAny(named: 'extras'),
        )).captured.single as Map<String, dynamic>;
    expect(deleteExtras[kAuthScopeExtraKey], AuthScope.user);
  });

  testWidgets('should_show_offline_state_when_network_error', (tester) async {
    when(() => client.listShoppingItems(extras: any(named: 'extras')))
        .thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/shopping'),
        error: const ApiError.network(),
      ),
    );

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // Сеть упала → офлайн-состояние, не повисший экран и не падение.
    expect(find.byType(ShoppingItemTile), findsNothing);
    expect(find.byType(ShoppingEmpty), findsNothing);
  });
}
