import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_item.freezed.dart';

/// Одна позиция персонального списка покупок (экран 19), источник —
/// `ShoppingItemDto` (`GET /api/v1/shopping`). Чистый Dart, иммутабельно.
///
/// Маппинг DTO → domain делает `ShoppingItemDtoMapper` (MADR-002).
/// [createdAt] backend отдаёт в UTC (или `null` — старые записи); если UI
/// захочет показать дату — приводит к локали (`createdAt?.toLocal()`), не эта
/// модель. Сортировку (сначала некупленные, затем купленные) задаёт backend —
/// клиент порядок не меняет.
@freezed
abstract class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    /// Идентификатор позиции (для `setChecked` / `deleteItem`).
    required int id,

    /// Текст позиции (с backend).
    required String title,

    /// Куплено ли уже (чек-бокс в UI).
    required bool checked,

    /// Момент создания в UTC; `null` — backend не вернул дату.
    DateTime? createdAt,
  }) = _ShoppingItem;

  const ShoppingItem._();
}
