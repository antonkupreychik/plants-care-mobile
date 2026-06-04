import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plantcare_mobile/features/report/presentation/report_format.dart';

void main() {
  setUpAll(() async {
    // monthLabel зовёт DateFormat.MMMM(локаль) — нужны загруженные символы.
    await initializeDateFormatting('ru');
  });

  group('ReportFormat.monthLabel', () {
    test('should_render_year_and_localized_month_name_for_ru', () {
      final label = ReportFormat.monthLabel('2026-05', 'ru');

      expect(label, contains('2026'));
      // Май в русской локали — «май» (регистр intl: строчная).
      expect(label.toLowerCase(), contains('май'));
    });

    test('should_return_input_unchanged_when_not_two_parts', () {
      expect(ReportFormat.monthLabel('2026', 'ru'), '2026');
      expect(ReportFormat.monthLabel('garbage', 'ru'), 'garbage');
    });

    test('should_return_input_unchanged_when_month_out_of_range', () {
      // m=13 невалиден → строка как есть, без падения DateTime.
      expect(ReportFormat.monthLabel('2026-13', 'ru'), '2026-13');
      expect(ReportFormat.monthLabel('2026-00', 'ru'), '2026-00');
    });

    test('should_return_input_unchanged_when_parts_not_numeric', () {
      expect(ReportFormat.monthLabel('2026-mm', 'ru'), '2026-mm');
    });
  });

  group('ReportFormat.weekNumber', () {
    test('should_extract_week_number_after_W_marker', () {
      expect(ReportFormat.weekNumber('2026-W19'), '19');
      expect(ReportFormat.weekNumber('2026-W01'), '01');
    });

    test('should_return_input_unchanged_when_no_W_marker', () {
      expect(ReportFormat.weekNumber('2026-19'), '2026-19');
      expect(ReportFormat.weekNumber('nope'), 'nope');
    });
  });
}
