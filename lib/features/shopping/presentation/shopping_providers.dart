import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/shopping_repository_provider.dart';
import '../domain/shopping_item.dart';
import 'shopping_state.dart';

part 'shopping_providers.g.dart';

/// State-слой списка покупок (экран 19).
///
/// Контракт для ui-builder:
/// - [shoppingControllerProvider] — `AsyncValue<ShoppingState>`
///   (loading / error / data). В `AsyncError` лежит типизированный `ApiError`.
///   Из `data` UI читает `state.items`, `state.isEmpty` (→ пустой экран),
///   `state.pendingCount`, `state.isMutating`. Методы контроллера:
///   `refresh()`, `addItem(String title)`, `toggleChecked(int id)`,
///   `deleteItem(int id)` — все `Future<void>`.
@riverpod
class ShoppingController extends _$ShoppingController {
  @override
  Future<ShoppingState> build() async {
    final items = await _fetch();
    return ShoppingState(items: items);
  }

  /// Перечитать список с backend (pull-to-refresh). Уходит в `AsyncLoading`,
  /// затем заново читает позиции.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => ShoppingState(items: await _fetch()));
  }

  /// Добавить позицию по тексту. После успеха перечитывает список целиком,
  /// чтобы получить присвоенный backend `id` и корректный порядок (backend
  /// сортирует некупленные сверху). При ошибке состояние остаётся прежним, а
  /// ошибка отдаётся вызвавшему UI как брошенный `ApiError` (для тоста/баннера).
  ///
  /// No-op для пустого/пробельного [title] (валидацию текста делает UI; здесь
  /// страховка от лишнего запроса).
  Future<void> addItem(String title) async {
    final trimmed = title.trim();
    final current = state.value;
    if (current == null || trimmed.isEmpty || current.isMutating) return;

    state = AsyncData(current.copyWith(isMutating: true));

    final result = await ref.read(shoppingRepositoryProvider).addItem(trimmed);

    if (!ref.mounted) return;

    switch (result) {
      case Success():
        // Перечитываем ради корректного порядка/id; список короткий.
        final items = await ref.read(shoppingRepositoryProvider).listItems();
        if (!ref.mounted) return;
        switch (items) {
          case Success(:final value):
            state = AsyncData(ShoppingState(items: value));
          case Failure(:final error):
            _restoreNotMutating();
            throw error;
        }
      case Failure(:final error):
        _restoreNotMutating();
        throw error;
    }
  }

  /// Переключить флаг «куплено» у позиции оптимистично: сразу инвертируем
  /// `checked` в [items], затем `PATCH {checked}`. При успехе подменяем позицию
  /// данными backend (на случай, если он что-то нормализовал), при ошибке —
  /// откат к снимку.
  ///
  /// No-op, если данных ещё нет, позиция не найдена или уже идёт мутация.
  Future<void> toggleChecked(int id) async {
    final current = state.value;
    if (current == null || current.isMutating) return;

    final index = current.items.indexWhere((i) => i.id == id);
    if (index < 0) return;

    final target = current.items[index];
    final next = !target.checked;

    final snapshot = current;
    final optimistic = _replaceAt(
      current,
      index,
      target.copyWith(checked: next),
    ).copyWith(isMutating: true);
    state = AsyncData(optimistic);

    final result = await ref
        .read(shoppingRepositoryProvider)
        .setChecked(id: id, checked: next);

    if (!ref.mounted) return;

    final latest = state.value;
    if (latest == null) return;

    switch (result) {
      case Success(:final value):
        final i = latest.items.indexWhere((it) => it.id == id);
        state = AsyncData(
          (i < 0 ? latest : _replaceAt(latest, i, value))
              .copyWith(isMutating: false),
        );
      case Failure(:final error):
        // Откат только если состояние с тех пор не уехало (refresh/другое
        // изменение). Иначе оставляем свежее, чтобы не затереть.
        if (identical(latest, optimistic)) {
          state = AsyncData(snapshot);
        } else {
          state = AsyncData(latest.copyWith(isMutating: false));
        }
        throw error;
    }
  }

  /// Удалить позицию оптимистично: сразу убираем из [items], затем
  /// `DELETE /{id}`. При ошибке — откат к снимку.
  ///
  /// No-op, если данных ещё нет, позиции нет или уже идёт мутация.
  Future<void> deleteItem(int id) async {
    final current = state.value;
    if (current == null || current.isMutating) return;

    final index = current.items.indexWhere((i) => i.id == id);
    if (index < 0) return;

    final snapshot = current;
    final optimistic = current.copyWith(
      items: [
        for (final i in current.items)
          if (i.id != id) i,
      ],
      isMutating: true,
    );
    state = AsyncData(optimistic);

    final result = await ref.read(shoppingRepositoryProvider).deleteItem(id);

    if (!ref.mounted) return;

    final latest = state.value;
    if (latest == null) return;

    switch (result) {
      case Success():
        state = AsyncData(latest.copyWith(isMutating: false));
      case Failure(:final error):
        if (identical(latest, optimistic)) {
          state = AsyncData(snapshot);
        } else {
          state = AsyncData(latest.copyWith(isMutating: false));
        }
        throw error;
    }
  }

  /// Снимает флаг [ShoppingState.isMutating], сохраняя текущие [items].
  void _restoreNotMutating() {
    final latest = state.value;
    if (latest != null) {
      state = AsyncData(latest.copyWith(isMutating: false));
    }
  }

  /// Заменяет позицию по индексу, сохраняя порядок.
  ShoppingState _replaceAt(ShoppingState s, int index, ShoppingItem item) {
    final updated = [...s.items];
    updated[index] = item;
    return s.copyWith(items: updated);
  }

  /// Читает список через репозиторий; `Result.failure` пробрасывается как
  /// бросок `ApiError` — Riverpod упакует его в `AsyncError` для первичной
  /// загрузки (`build`) / `refresh`.
  Future<List<ShoppingItem>> _fetch() async {
    final result = await ref.read(shoppingRepositoryProvider).listItems();
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }
}
