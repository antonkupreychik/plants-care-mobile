import '../../../../core/api/generated/models/shopping_item_dto.dart';
import '../../domain/shopping_item.dart';

/// Маппинг [ShoppingItemDto] (`/api/v1/shopping`) → domain [ShoppingItem]
/// (MADR-002). Точка нормализации контракта. 1:1 по полям контракта
/// (id/title/checked/createdAt) — дополнительных полей дизайна (категории,
/// AI-бейджи) в контракте нет, потому их здесь нет.
extension ShoppingItemDtoMapper on ShoppingItemDto {
  ShoppingItem toDomain() => ShoppingItem(
        id: id,
        title: title,
        checked: checked,
        createdAt: createdAt,
      );
}
