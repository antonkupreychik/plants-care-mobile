import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/api_error_l10n.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/offline_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/shopping/data/shopping_repository_provider.dart';
import 'package:plantcare_mobile/features/shopping/domain/shopping_item.dart';
import 'package:plantcare_mobile/features/shopping/domain/shopping_repository.dart';
import 'package:plantcare_mobile/features/shopping/presentation/shopping_screen.dart';
import 'package:plantcare_mobile/features/shopping/presentation/widgets/shopping_empty.dart';
import 'package:plantcare_mobile/features/shopping/presentation/widgets/shopping_item_tile.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements ShoppingRepository {}

Future<T> _pending<T>() => Completer<T>().future;

ShoppingItem _item(int id, {bool checked = false, String? title}) =>
    ShoppingItem(
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

Widget _wrap(ShoppingRepository repo) => ProviderScope(
      overrides: [shoppingRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const ShoppingScreen(),
      ),
    );

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(ShoppingScreen)));

void main() {
  setUpAll(() => registerFallbackValue(StackTrace.empty));

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  void stubList(Result<List<ShoppingItem>> result) {
    when(() => repo.listItems()).thenAnswer((_) async => result);
  }

  group('states', () {
    testWidgets('should_show_skeleton_when_loading', (tester) async {
      when(() => repo.listItems())
          .thenAnswer((_) => _pending<Result<List<ShoppingItem>>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(SkeletonBox), findsWidgets);
      expect(find.byType(ShoppingItemTile), findsNothing);
    });

    testWidgets('should_show_offline_state_when_NetworkError', (tester) async {
      stubList(const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // NetworkError → полноэкранный OfflineState (экран 29), не ErrorState.
      expect(find.byType(OfflineState), findsOneWidget);
      expect(find.byType(ErrorState), findsNothing);
    });

    testWidgets('should_show_errorState_for_non_network_error', (tester) async {
      stubList(const Result.failure(ApiError.accessDenied()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.byType(OfflineState), findsNothing);
      expect(find.text(_l10n(tester).retry), findsOneWidget);
    });

    testWidgets('should_recover_to_data_when_error_retry_tapped',
        (tester) async {
      _tallSurface(tester);
      var healed = false;
      when(() => repo.listItems()).thenAnswer((_) async {
        if (!healed) return const Result.failure(ApiError.accessDenied());
        return Result.success([_item(1)]);
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);

      healed = true;
      await tester.tap(find.text(_l10n(tester).retry));
      await tester.pumpAndSettle();

      // refresh() перечитал список → данные показаны, ошибки нет.
      expect(find.byType(ErrorState), findsNothing);
      expect(find.byType(ShoppingItemTile), findsOneWidget);
    });

    testWidgets('should_show_empty_when_list_empty', (tester) async {
      stubList(const Result.success([]));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ShoppingEmpty), findsOneWidget);
      expect(find.byType(ShoppingItemTile), findsNothing);
    });

    testWidgets('should_render_tiles_and_counter_when_data', (tester) async {
      _tallSurface(tester);
      stubList(
        Result.success([_item(1), _item(2, checked: true), _item(3)]),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ShoppingItemTile), findsNWidgets(3));
      expect(find.byType(ShoppingEmpty), findsNothing);
      // Счётчик «3 позиции · 1 куплено» (total=3, bought=1).
      expect(find.text(_l10n(tester).shoppingHeroSummary(3, 1)), findsOneWidget);
    });
  });

  group('interactions', () {
    testWidgets('should_call_setChecked_when_checkbox_tile_tapped',
        (tester) async {
      _tallSurface(tester);
      stubList(Result.success([_item(1, checked: false)]));
      when(() => repo.setChecked(id: 1, checked: true))
          .thenAnswer((_) async => Result.success(_item(1, checked: true)));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ShoppingItemTile).first);
      await tester.pumpAndSettle();

      // Тап по строке инвертирует checked false→true.
      verify(() => repo.setChecked(id: 1, checked: true)).called(1);
    });

    testWidgets('should_call_deleteItem_when_swiped', (tester) async {
      _tallSurface(tester);
      stubList(Result.success([_item(1), _item(2)]));
      when(() => repo.deleteItem(1))
          .thenAnswer((_) async => const Result.success(null));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(ShoppingItemTile).first,
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      verify(() => repo.deleteItem(1)).called(1);
    });

    // Регрессия: при провале удаления (офлайн) контроллер оптимистично убирает
    // позицию, затем откатывает (возвращает в state) и бросает ApiError.
    // _DataView._delete ловит → снэкбар + возвращает false из confirmDismiss,
    // поэтому Dismissible откатывает свайп и виджет остаётся в дереве.
    // Без confirmDismiss этот тест падал бы с ассертом
    // «A dismissed Dismissible widget is still part of the tree» либо позиция
    // исчезла бы из UI при том, что в state она есть.
    testWidgets('should_keep_item_and_show_snackbar_when_swipe_delete_fails',
        (tester) async {
      _tallSurface(tester);
      stubList(Result.success([_item(1), _item(2)]));
      when(() => repo.deleteItem(1))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ShoppingItemTile), findsNWidgets(2));

      await tester.drag(
        find.byType(ShoppingItemTile).first,
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Удаление действительно ушло в репозиторий и провалилось.
      verify(() => repo.deleteItem(1)).called(1);

      // 1) Позиция осталась в списке (откат отрисован, не потерялась из UI).
      expect(find.byType(ShoppingItemTile), findsNWidgets(2));
      expect(find.text('Позиция 1'), findsOneWidget);

      // 2) Снэкбар с локализованным текстом сетевой ошибки.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(_l10n(tester).messageForError(const ApiError.network())),
          findsOneWidget);

      // 3) Тест дошёл сюда без ассерта «dismissed Dismissible is still part of
      //    the tree» — confirmDismiss корректно откатил свайп.
    });

    testWidgets('should_open_sheet_and_addItem_with_typed_title',
        (tester) async {
      _tallSurface(tester);
      var listCalls = 0;
      when(() => repo.listItems()).thenAnswer((_) async {
        listCalls++;
        if (listCalls == 1) return Result.success([_item(1)]);
        return Result.success([_item(1), _item(2, title: 'Удобрение')]);
      });
      when(() => repo.addItem('Удобрение'))
          .thenAnswer((_) async => Result.success(_item(2, title: 'Удобрение')));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // «Добавить позицию» внизу списка открывает sheet.
      await tester.tap(find.text(_l10n(tester).shoppingAddItem));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Удобрение');
      await tester.pump();
      await tester.tap(find.text(_l10n(tester).shoppingAddSheetSubmit));
      await tester.pumpAndSettle();

      verify(() => repo.addItem('Удобрение')).called(1);
    });

    testWidgets('should_show_snackbar_when_toggle_fails', (tester) async {
      _tallSurface(tester);
      stubList(Result.success([_item(1, checked: false)]));
      when(() => repo.setChecked(id: 1, checked: true))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ShoppingItemTile).first);
      await tester.pump(); // дать снэкбару появиться

      // Ошибка мутации поймана экраном и показана снэкбаром.
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
