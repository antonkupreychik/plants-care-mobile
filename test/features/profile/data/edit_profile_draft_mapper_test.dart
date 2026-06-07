import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_locale.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_seasonal_mode.dart';
import 'package:plantcare_mobile/features/profile/data/mappers/edit_profile_draft_mapper.dart';

MeResponse _me({
  String? name = 'Антон',
  String quietHoursStart = '22:00',
  String quietHoursEnd = '08:00',
  String timezone = 'Europe/Moscow',
}) =>
    MeResponse(
      id: 1,
      emailVerified: true,
      createdAt: DateTime.utc(2025, 5, 3, 10),
      name: name,
      plantsTotal: 12,
      tasksToday: 0,
      totalCareEvents: 0,
      notificationsUnread: 0,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      timezone: timezone,
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
    );

void main() {
  group('MeResponseEditProfileMapper.toEditProfileDraft', () {
    test('should_map_editable_fields', () {
      final draft = _me().toEditProfileDraft();

      expect(draft.quietHoursStart, '22:00');
      expect(draft.quietHoursEnd, '08:00');
      expect(draft.timezone, 'Europe/Moscow');
      expect(draft.displayName, 'Антон');
    });

    test('should_pass_through_null_name', () {
      final draft = _me(name: null).toEditProfileDraft();
      expect(draft.displayName, isNull);
    });

    test('should_pass_through_different_timezone', () {
      final draft = _me(timezone: 'Asia/Yekaterinburg').toEditProfileDraft();
      expect(draft.timezone, 'Asia/Yekaterinburg');
    });

    test('should_pass_through_different_quiet_hours', () {
      final draft = _me(quietHoursStart: '23:00', quietHoursEnd: '07:00')
          .toEditProfileDraft();
      expect(draft.quietHoursStart, '23:00');
      expect(draft.quietHoursEnd, '07:00');
    });
  });
}
