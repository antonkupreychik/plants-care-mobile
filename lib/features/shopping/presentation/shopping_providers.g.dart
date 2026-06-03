// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой списка покупок (экран 19).
///
/// Контракт для ui-builder:
/// - [shoppingControllerProvider] — `AsyncValue<ShoppingState>`
///   (loading / error / data). В `AsyncError` лежит типизированный `ApiError`.
///   Из `data` UI читает `state.items`, `state.isEmpty` (→ пустой экран),
///   `state.pendingCount`, `state.isMutating`. Методы контроллера:
///   `refresh()`, `addItem(String title)`, `toggleChecked(int id)`,
///   `deleteItem(int id)` — все `Future<void>`.

@ProviderFor(ShoppingController)
final shoppingControllerProvider = ShoppingControllerProvider._();

/// State-слой списка покупок (экран 19).
///
/// Контракт для ui-builder:
/// - [shoppingControllerProvider] — `AsyncValue<ShoppingState>`
///   (loading / error / data). В `AsyncError` лежит типизированный `ApiError`.
///   Из `data` UI читает `state.items`, `state.isEmpty` (→ пустой экран),
///   `state.pendingCount`, `state.isMutating`. Методы контроллера:
///   `refresh()`, `addItem(String title)`, `toggleChecked(int id)`,
///   `deleteItem(int id)` — все `Future<void>`.
final class ShoppingControllerProvider
    extends $AsyncNotifierProvider<ShoppingController, ShoppingState> {
  /// State-слой списка покупок (экран 19).
  ///
  /// Контракт для ui-builder:
  /// - [shoppingControllerProvider] — `AsyncValue<ShoppingState>`
  ///   (loading / error / data). В `AsyncError` лежит типизированный `ApiError`.
  ///   Из `data` UI читает `state.items`, `state.isEmpty` (→ пустой экран),
  ///   `state.pendingCount`, `state.isMutating`. Методы контроллера:
  ///   `refresh()`, `addItem(String title)`, `toggleChecked(int id)`,
  ///   `deleteItem(int id)` — все `Future<void>`.
  ShoppingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingControllerHash();

  @$internal
  @override
  ShoppingController create() => ShoppingController();
}

String _$shoppingControllerHash() =>
    r'c400b231e9d552d92aace23ab804df1482f8eb79';

/// State-слой списка покупок (экран 19).
///
/// Контракт для ui-builder:
/// - [shoppingControllerProvider] — `AsyncValue<ShoppingState>`
///   (loading / error / data). В `AsyncError` лежит типизированный `ApiError`.
///   Из `data` UI читает `state.items`, `state.isEmpty` (→ пустой экран),
///   `state.pendingCount`, `state.isMutating`. Методы контроллера:
///   `refresh()`, `addItem(String title)`, `toggleChecked(int id)`,
///   `deleteItem(int id)` — все `Future<void>`.

abstract class _$ShoppingController extends $AsyncNotifier<ShoppingState> {
  FutureOr<ShoppingState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ShoppingState>, ShoppingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ShoppingState>, ShoppingState>,
              AsyncValue<ShoppingState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
