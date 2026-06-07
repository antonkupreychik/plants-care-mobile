import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_locale.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_seasonal_mode.dart';
import 'package:plantcare_mobile/features/profile/data/mappers/profile_summary_mapper.dart';

MeResponse _me({
  String? name = 'Антон',
  String? email = 'anton@example.com',
  String? avatar,
  int plantsTotal = 12,
  DateTime? createdAt,
}) =>
    MeResponse(
      id: 1,
      emailVerified: true,
      createdAt: createdAt ?? DateTime.utc(2025, 5, 3, 10),
      name: name,
      plantsTotal: plantsTotal,
      tasksToday: 0,
      totalCareEvents: 0,
      notificationsUnread: 0,
      quietHoursStart: '22:00',
      quietHoursEnd: '08:00',
      timezone: 'Europe/Moscow',
      locale: MeResponseLocale.ru,
      seasonalEnabled: false,
      seasonalMode: MeResponseSeasonalMode.multiplier,
      weatherEnabled: false,
      featureFlags: const <String, Object?>{},
      appleLinked: false,
      googleLinked: false,
      emailLinked: true,
      telegramLinked: false,
      isGuest: false,
      email: email,
      avatar: avatar,
    );

void main() {
  group('MeResponseProfileMapper.toProfileSummary', () {
    test('should_map_presentational_fields', () {
      final summary = _me().toProfileSummary();

      expect(summary.name, 'Антон');
      expect(summary.email, 'anton@example.com');
      expect(summary.avatar, isNull);
      expect(summary.plantsTotal, 12);
      expect(summary.createdAt, DateTime.utc(2025, 5, 3, 10));
    });

    test('should_leave_totalCareEvents_null_until_backend_adds_field', () {
      // Поле ещё не в MeResponse (plants-care#226) — маппер всегда даёт null,
      // UI скрывает блок «Уходов».
      expect(_me().toProfileSummary().totalCareEvents, isNull);
    });

    test('should_pass_through_null_name_and_email', () {
      final summary = _me(name: null, email: null).toProfileSummary();
      expect(summary.name, isNull);
      expect(summary.email, isNull);
    });

    test('should_pass_through_avatar_url_when_present', () {
      final summary = _me(avatar: 'https://cdn.test/a.png').toProfileSummary();
      expect(summary.avatar, 'https://cdn.test/a.png');
    });
  });

  group('ProfileSummary.initial', () {
    test('should_use_first_letter_uppercased', () {
      expect(_me(name: 'антон').toProfileSummary().initial, 'А');
    });

    test('should_fallback_to_question_mark_when_no_name', () {
      expect(_me(name: null).toProfileSummary().initial, '?');
      expect(_me(name: '   ').toProfileSummary().initial, '?');
    });
  });
}
