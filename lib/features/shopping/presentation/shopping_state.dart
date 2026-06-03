import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/shopping_item.dart';

part 'shopping_state.freezed.dart';

/// Состояние экрана списка покупок (экран 19).
///
/// Presentation-state (роль ViewModel): держит все позиции ([items], порядок
/// backend — сначала некупленные, затем купленные) и флаг идущей мутации
/// ([isMutating]) для add/toggle/delete. Иммутабелен — мутируется только
/// `ShoppingController`.
///
/// Первичная загрузка/ошибка выражаются `AsyncValue` снаружи (loading/error),
/// а пустое состояние ([isEmpty] → пустой экран) выводит UI из [items]. Это
/// контракт для ui-builder.
@freezed
abstract class ShoppingState with _$ShoppingState {
  const factory ShoppingState({
    /// Все позиции списка, порядок backend (некупленные сверху).
    required List<ShoppingItem> items,

    /// Идёт мутация (add/toggle/delete). UI может блокировать повторные тапы
    /// или показывать индикатор. Оптимистичные изменения уже отражены в
    /// [items], этот флаг — про «летит» ли запрос.
    @Default(false) bool isMutating,
  }) = _ShoppingState;

  const ShoppingState._();

  /// Список пуст → пустое состояние экрана.
  bool get isEmpty => items.isEmpty;

  /// Сколько позиций ещё не куплено (для подзаголовка/счётчика в UI).
  int get pendingCount => items.where((i) => !i.checked).length;
}
