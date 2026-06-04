import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/shopping/data/shopping_repository_provider.dart';
import 'package:plantcare_mobile/features/shopping/domain/shopping_item.dart';
import 'package:plantcare_mobile/features/shopping/domain/shopping_repository.dart';
import 'package:plantcare_mobile/features/shopping/presentation/shopping_providers.dart';
import 'package:plantcare_mobile/features/shopping/presentation/shopping_state.dart';

class _MockRepo extends Mock implements ShoppingRepository {}

ShoppingItem _item(int id, {bool checked = false, String? title}) =>
    ShoppingItem(
      id: id,
      title: title ?? 'Позиция $id',
      checked: checked,
      createdAt: DateTime.utc(2026, 6, 1, 9),
    );

ProviderContainer _containerWith(ShoppingRepository repo) {
  final container = ProviderContainer(
    overrides: [shoppingRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Подписка удерживает autoDispose-провайдер живым между чтениями.
void _keepAlive(ProviderContainer container) {
  final sub = container.listen(shoppingControllerProvider, (_, _) {});
  addTearDown(sub.close);
}

ShoppingState _state(ProviderContainer c) =>
    c.read(shoppingControllerProvider).value!;

/// Подписывается на провайдер и ждёт первого перехода в ошибку (подписка
/// удерживает autoDispose-провайдер живым).
Future<Object?> _awaitError(ProviderContainer container) {
  final completer = Completer<Object?>();
  final sub = container.listen(shoppingControllerProvider, (_, next) {
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

  group('state getters', () {
    test('should_report_isEmpty_and_pendingCount_from_items', () {
      const empty = ShoppingState(items: []);
      expect(empty.isEmpty, isTrue);
      expect(empty.pendingCount, 0);

      final state = ShoppingState(
        items: [_item(1), _item(2, checked: true), _item(3)],
      );
      expect(state.isEmpty, isFalse);
      // Куплена только 2 → не куплено 2.
      expect(state.pendingCount, 2);
    });
  });

  group('initial build', () {
    test('should_load_items_into_data', () async {
      when(() => repo.listItems()).thenAnswer(
        (_) async => Result.success([_item(1), _item(2)]),
      );
      final container = _containerWith(repo);

      final state = await container.read(shoppingControllerProvider.future);

      expect(state.items.map((e) => e.id), [1, 2]);
      expect(state.isEmpty, isFalse);
      verify(() => repo.listItems()).called(1);
    });

    test('should_expose_isEmpty_when_list_empty', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => const Result.success([]));
      final container = _containerWith(repo);

      final state = await container.read(shoppingControllerProvider.future);

      expect(state.isEmpty, isTrue);
    });

    test('should_throw_ApiError_into_AsyncError_when_load_fails', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);

      final error = await _awaitError(container);

      expect(error, const ApiError.network());
    });
  });

  group('addItem', () {
    test('should_be_noop_for_blank_title_and_not_call_repo', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1)]));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      await container.read(shoppingControllerProvider.notifier).addItem('   ');

      verifyNever(() => repo.addItem(any()));
    });

    test('should_add_trimmed_title_then_refetch_full_list', () async {
      var listCalls = 0;
      when(() => repo.listItems()).thenAnswer((_) async {
        listCalls++;
        if (listCalls == 1) return Result.success([_item(1)]);
        // Re-fetch после add: backend вернул новую позицию с присвоенным id.
        return Result.success([_item(1), _item(2, title: 'Удобрение')]);
      });
      when(() => repo.addItem('Удобрение'))
          .thenAnswer((_) async => Result.success(_item(2, title: 'Удобрение')));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      await container
          .read(shoppingControllerProvider.notifier)
          .addItem('  Удобрение  ');

      // Триммит перед отправкой.
      verify(() => repo.addItem('Удобрение')).called(1);
      // После успеха перечитывает список целиком (build + re-fetch).
      verify(() => repo.listItems()).called(2);
      final state = _state(container);
      expect(state.items.map((e) => e.id), [1, 2]);
      expect(state.isMutating, isFalse);
    });

    test('should_rethrow_error_and_keep_list_when_add_fails', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1)]));
      when(() => repo.addItem(any()))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);

      await expectLater(
        container.read(shoppingControllerProvider.notifier).addItem('Грунт'),
        throwsA(const ApiError.network()),
      );

      // Список не изменился, флаг мутации снят, re-fetch не делался.
      final state = _state(container);
      expect(state.items.map((e) => e.id), [1]);
      expect(state.isMutating, isFalse);
      verify(() => repo.listItems()).called(1);
    });
  });

  group('toggleChecked', () {
    test('should_flip_checked_optimistically_before_network_answers',
        () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1)]));
      // setChecked зависает — проверяем состояние ДО ответа сети.
      final pending = Completer<Result<ShoppingItem>>();
      when(() => repo.setChecked(id: 1, checked: true))
          .thenAnswer((_) => pending.future);
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      final future = container
          .read(shoppingControllerProvider.notifier)
          .toggleChecked(1);

      // Оптимистично, ещё до завершения сети.
      final optimistic = _state(container);
      expect(optimistic.items.firstWhere((e) => e.id == 1).checked, isTrue);
      expect(optimistic.isMutating, isTrue);

      pending.complete(Result.success(_item(1, checked: true)));
      await future;

      final after = _state(container);
      expect(after.items.firstWhere((e) => e.id == 1).checked, isTrue);
      expect(after.isMutating, isFalse);
    });

    test('should_rollback_and_rethrow_when_toggle_fails', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1, checked: false)]));
      when(() => repo.setChecked(id: 1, checked: true))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);

      await expectLater(
        container.read(shoppingControllerProvider.notifier).toggleChecked(1),
        throwsA(const ApiError.network()),
      );

      // Откат к исходному checked=false, флаг мутации снят.
      final after = _state(container);
      expect(after.items.firstWhere((e) => e.id == 1).checked, isFalse);
      expect(after.isMutating, isFalse);
    });

    test('should_be_noop_when_id_not_found', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1)]));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      await container
          .read(shoppingControllerProvider.notifier)
          .toggleChecked(999);

      verifyNever(() => repo.setChecked(
            id: any(named: 'id'),
            checked: any(named: 'checked'),
          ));
    });
  });

  group('deleteItem', () {
    test('should_remove_item_optimistically_before_network_answers', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1), _item(2)]));
      final pending = Completer<Result<void>>();
      when(() => repo.deleteItem(1)).thenAnswer((_) => pending.future);
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      final future =
          container.read(shoppingControllerProvider.notifier).deleteItem(1);

      // Оптимистично убрана до ответа сети.
      final optimistic = _state(container);
      expect(optimistic.items.map((e) => e.id), [2]);
      expect(optimistic.isMutating, isTrue);

      pending.complete(const Result.success(null));
      await future;

      final after = _state(container);
      expect(after.items.map((e) => e.id), [2]);
      expect(after.isMutating, isFalse);
    });

    test('should_restore_item_and_rethrow_when_delete_fails', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1), _item(2)]));
      when(() => repo.deleteItem(1))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);

      await expectLater(
        container.read(shoppingControllerProvider.notifier).deleteItem(1),
        throwsA(const ApiError.network()),
      );

      // Откат: позиция вернулась, флаг мутации снят.
      final after = _state(container);
      expect(after.items.map((e) => e.id), [1, 2]);
      expect(after.isMutating, isFalse);
    });

    test('should_be_noop_when_id_not_found', () async {
      when(() => repo.listItems())
          .thenAnswer((_) async => Result.success([_item(1)]));
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      await container
          .read(shoppingControllerProvider.notifier)
          .deleteItem(999);

      verifyNever(() => repo.deleteItem(any()));
    });
  });

  group('refresh', () {
    test('should_reload_list_from_repo', () async {
      var calls = 0;
      when(() => repo.listItems()).thenAnswer((_) async {
        calls++;
        if (calls == 1) return Result.success([_item(1)]);
        return Result.success([_item(9), _item(10)]);
      });
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      await container.read(shoppingControllerProvider.notifier).refresh();

      expect(_state(container).items.map((e) => e.id), [9, 10]);
      verify(() => repo.listItems()).called(2);
    });

    test('should_go_to_AsyncError_when_refresh_fails', () async {
      var calls = 0;
      when(() => repo.listItems()).thenAnswer((_) async {
        calls++;
        if (calls == 1) return Result.success([_item(1)]);
        return const Result.failure(ApiError.network());
      });
      final container = _containerWith(repo);
      _keepAlive(container);

      await container.read(shoppingControllerProvider.future);
      await container.read(shoppingControllerProvider.notifier).refresh();

      final async = container.read(shoppingControllerProvider);
      expect(async.hasError, isTrue);
      expect(async.error, const ApiError.network());
    });
  });
}
