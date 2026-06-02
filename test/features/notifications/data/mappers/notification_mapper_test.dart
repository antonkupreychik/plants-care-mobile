import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/notification_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/notification_dto_type.dart';
import 'package:plantcare_mobile/features/notifications/data/mappers/notification_mapper.dart';
import 'package:plantcare_mobile/features/notifications/domain/notification_type.dart';

NotificationDto _dto({
  int id = 1,
  NotificationDtoType type = NotificationDtoType.care,
  String title = 'Фикус хочет пить',
  String body = 'Полей меня сегодня',
  DateTime? createdAt,
  DateTime? readAt,
  int? plantId = 42,
}) =>
    NotificationDto(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt ?? DateTime.utc(2026, 6, 1, 9),
      readAt: readAt,
      plantId: plantId,
    );

void main() {
  group('NotificationDtoMapper.toDomain', () {
    test('should_copy_all_scalar_fields_one_to_one', () {
      final dto = _dto(
        id: 7,
        title: 'Заголовок',
        body: 'Тело',
        createdAt: DateTime.utc(2026, 6, 1, 9, 30),
        plantId: 99,
      );

      final item = dto.toDomain();

      expect(item.id, 7);
      expect(item.title, 'Заголовок');
      expect(item.body, 'Тело');
      expect(item.createdAt, DateTime.utc(2026, 6, 1, 9, 30));
      expect(item.plantId, 99);
    });

    test('should_set_isRead_false_when_readAt_null', () {
      final item = _dto(readAt: null).toDomain();

      expect(item.readAt, isNull);
      expect(item.isRead, isFalse);
    });

    test('should_set_isRead_true_and_keep_readAt_when_readAt_present', () {
      final readAt = DateTime.utc(2026, 6, 1, 10);

      final item = _dto(readAt: readAt).toDomain();

      expect(item.readAt, readAt);
      expect(item.isRead, isTrue);
    });

    test('should_carry_null_plantId_for_unlinked_notification', () {
      final item = _dto(plantId: null).toDomain();

      expect(item.plantId, isNull);
    });

    group('type mapping', () {
      test('should_map_care_to_care', () {
        expect(
          _dto(type: NotificationDtoType.care).toDomain().type,
          NotificationType.care,
        );
      });

      test('should_map_alert_to_alert', () {
        expect(
          _dto(type: NotificationDtoType.alert).toDomain().type,
          NotificationType.alert,
        );
      });

      test('should_map_award_to_award', () {
        expect(
          _dto(type: NotificationDtoType.award).toDomain().type,
          NotificationType.award,
        );
      });

      test('should_map_report_to_report', () {
        expect(
          _dto(type: NotificationDtoType.report).toDomain().type,
          NotificationType.report,
        );
      });

      test('should_map_system_to_system', () {
        expect(
          _dto(type: NotificationDtoType.system).toDomain().type,
          NotificationType.system,
        );
      });

      // Контракт мог добавить тип; нераспознанный код НЕ роняет ленту,
      // схлопывается в нейтральный system. Регрессия здесь (например, throw на
      // default) уронила бы весь экран.
      test('should_fallback_unknown_type_to_system', () {
        expect(
          _dto(type: NotificationDtoType.$unknown).toDomain().type,
          NotificationType.system,
        );
      });
    });
  });
}
