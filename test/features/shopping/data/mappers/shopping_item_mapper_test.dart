import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/shopping_item_dto.dart';
import 'package:plantcare_mobile/features/shopping/data/mappers/shopping_item_mapper.dart';

ShoppingItemDto _dto({
  int id = 1,
  String title = 'Грунт для суккулентов',
  bool checked = false,
  DateTime? createdAt,
}) =>
    ShoppingItemDto(
      id: id,
      title: title,
      checked: checked,
      createdAt: createdAt,
    );

void main() {
  group('ShoppingItemDtoMapper.toDomain', () {
    test('should_copy_all_scalar_fields_one_to_one', () {
      final dto = _dto(
        id: 7,
        title: 'Керамзит',
        checked: true,
        createdAt: DateTime.utc(2026, 6, 1, 9, 30),
      );

      final item = dto.toDomain();

      expect(item.id, 7);
      expect(item.title, 'Керамзит');
      expect(item.checked, isTrue);
      expect(item.createdAt, DateTime.utc(2026, 6, 1, 9, 30));
    });

    test('should_keep_createdAt_null_when_dto_has_no_date', () {
      // Старые записи backend отдаёт без createdAt — маппер не подставляет
      // суррогат, иначе UI показал бы фантомную дату.
      final item = _dto(createdAt: null).toDomain();

      expect(item.createdAt, isNull);
    });

    test('should_map_checked_false_for_unbought_item', () {
      expect(_dto(checked: false).toDomain().checked, isFalse);
    });
  });
}
