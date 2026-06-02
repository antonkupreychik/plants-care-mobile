import '../../../core/error/result.dart';
import 'shopping_item.dart';

/// Контракт data-слоя списка покупок (экран 19, `GET/POST/PATCH/DELETE
/// /api/v1/shopping`).
///
/// Четыре действия: прочитать список, добавить позицию, переключить флаг
/// «куплено», удалить позицию. Все возвращают `Future<Result<T>>` и НЕ бросают
/// наружу (MADR-011). Идентичность пользователя backend резолвит из bearer-
/// токена (`sub`) — здесь она не передаётся (см. `AuthInterceptor`, MADR-008).
abstract interface class ShoppingRepository {
  /// Весь список покупок пользователя (`GET /api/v1/shopping`).
  /// Backend отдаёт сначала некупленные, затем купленные; без пагинации.
  Future<Result<List<ShoppingItem>>> listItems();

  /// Добавить позицию по тексту (`POST /api/v1/shopping`). Возвращает
  /// созданную позицию (с присвоенным backend `id`). Пустой/слишком длинный
  /// [title] — `ApiError` (backend 400).
  Future<Result<ShoppingItem>> addItem(String title);

  /// Переключить флаг «куплено» (`PATCH /api/v1/shopping/{id}` с `{checked}`).
  /// Возвращает обновлённую позицию.
  Future<Result<ShoppingItem>> setChecked({
    required int id,
    required bool checked,
  });

  /// Удалить позицию (`DELETE /api/v1/shopping/{id}`). Чужая/несуществующая —
  /// `ApiError` (backend 404).
  Future<Result<void>> deleteItem(int id);
}
