import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_page.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';

CareHistoryEntry _entry(int id) => CareHistoryEntry(
      id: id,
      plantId: 1,
      plantName: 'Фикус',
      kind: CareEventKind.water,
      performedAt: DateTime.utc(2026, 5, 1, 8),
      onTime: true,
    );

void main() {
  group('CareHistoryPage.hasMore', () {
    test('should_be_true_when_loaded_window_ends_before_total', () {
      final page = CareHistoryPage(
        items: [_entry(1), _entry(2)],
        total: 5,
        limit: 50,
        offset: 0,
      );

      // offset(0) + items(2) = 2 < total(5).
      expect(page.hasMore, isTrue);
    });

    test('should_be_false_when_window_reaches_total', () {
      final page = CareHistoryPage(
        items: [_entry(3), _entry(4)],
        total: 4,
        limit: 50,
        offset: 2,
      );

      // offset(2) + items(2) = 4, не меньше total(4).
      expect(page.hasMore, isFalse);
    });

    test('should_account_for_offset_of_later_page', () {
      final page = CareHistoryPage(
        items: [_entry(11)],
        total: 12,
        limit: 50,
        offset: 10,
      );

      // offset(10) + items(1) = 11 < total(12) — ещё одна запись впереди.
      expect(page.hasMore, isTrue);
    });
  });
}
