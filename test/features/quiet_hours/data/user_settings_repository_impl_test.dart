import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/me_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_locale.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_seasonal_mode.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/quiet_hours/data/user_settings_repository_impl.dart';
import 'package:plantcare_mobile/features/quiet_hours/domain/quiet_time.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockMeClient extends Mock implements MeClient {}

class _FakeUpdateRequest extends Fake implements MeUpdateRequest {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/me'),
      error: error,
    );

MeResponse _me({
  String quietStart = '22:00',
  String quietEnd = '08:00',
  String timezone = 'Europe/Moscow',
  MeResponseLocale locale = MeResponseLocale.ru,
}) =>
    MeResponse(
      id: 1,
      emailVerified: true,
      createdAt: DateTime.utc(2026, 1, 1),
      name: 'Test',
      plantsTotal: 0,
      tasksToday: 0,
      totalCareEvents: 0,
      notificationsUnread: 0,
      quietHoursStart: quietStart,
      quietHoursEnd: quietEnd,
      timezone: timezone,
      locale: locale,
      seasonalEnabled: false,
      seasonalMode: MeResponseSeasonalMode.multiplier,
      weatherEnabled: false,
      featureFlags: null,
      appleLinked: false,
      googleLinked: false,
      emailLinked: false,
      telegramLinked: false,
      isGuest: false,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeUpdateRequest());
  });

  late _MockApi api;
  late _MockMeClient client;
  late UserSettingsRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockMeClient();
    when(() => api.me).thenReturn(client);
    repo = UserSettingsRepositoryImpl(api);
  });

  group('getSettings', () {
    test('should_map_MeResponse_to_UserSettings', () async {
      when(() => client.getMe(extras: any(named: 'extras')))
          .thenAnswer((_) async => _me());

      final result = await repo.getSettings();

      final settings = (result as Success).value;
      expect(settings.quietHoursStart, const QuietTime(hour: 22, minute: 0));
      expect(settings.quietHoursEnd, const QuietTime(hour: 8, minute: 0));
      expect(settings.timezone, 'Europe/Moscow');
    });

    // Auth-слот: user-scoped, Bearer ставит AuthInterceptor из AuthSession.
    // Ловит молчаливую регрессию scope при подключении реального auth.
    // Идентичность здесь НЕ хардкодится — проверяем только проброс scope.
    test('should_send_user_authScope_in_extras', () async {
      when(() => client.getMe(extras: any(named: 'extras')))
          .thenAnswer((_) async => _me());

      await repo.getSettings();

      final captured = verify(() => client.getMe(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_with_ApiError_from_DioException_without_throw',
        () async {
      when(() => client.getMe(extras: any(named: 'extras')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getSettings();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.getMe(extras: any(named: 'extras')))
          .thenThrow(_dioWith('boom'));

      final result = await repo.getSettings();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('updateQuietHours', () {
    test('should_send_only_start_when_only_start_changed', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me());

      await repo.updateQuietHours(start: const QuietTime(hour: 23, minute: 30));

      final body = verify(() => client.updateMe(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as MeUpdateRequest;
      // PATCH-семантика: шлём только изменённое поле.
      expect(body.quietHoursStart, '23:30');
      expect(body.quietHoursEnd, isNull);
      expect(body.timezone, isNull);
    });

    test('should_send_both_start_and_end_when_both_changed', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me());

      await repo.updateQuietHours(
        start: const QuietTime(hour: 22, minute: 0),
        end: const QuietTime(hour: 7, minute: 15),
      );

      final body = verify(() => client.updateMe(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as MeUpdateRequest;
      expect(body.quietHoursStart, '22:00');
      expect(body.quietHoursEnd, '07:15');
      expect(body.timezone, isNull);
    });

    test('should_map_response_to_UserSettings', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me(quietStart: '21:00'));

      final result =
          await repo.updateQuietHours(start: const QuietTime(hour: 21, minute: 0));

      expect((result as Success).value.quietHoursStart,
          const QuietTime(hour: 21, minute: 0));
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me());

      await repo.updateQuietHours(start: const QuietTime(hour: 22, minute: 0));

      final captured = verify(() => client.updateMe(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_when_backend_rejects_equal_start_end',
        () async {
      // start == end → backend 400, нормализован в ApiError.badRequest.
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest()));

      final result = await repo.updateQuietHours(
        start: const QuietTime(hour: 8, minute: 0),
        end: const QuietTime(hour: 8, minute: 0),
      );

      expect((result as Failure).error, const ApiError.badRequest());
    });
  });

  group('updateTimezone', () {
    test('should_send_only_timezone_field', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me(timezone: 'Asia/Yekaterinburg'));

      await repo.updateTimezone('Asia/Yekaterinburg');

      final body = verify(() => client.updateMe(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as MeUpdateRequest;
      expect(body.timezone, 'Asia/Yekaterinburg');
      expect(body.quietHoursStart, isNull);
      expect(body.quietHoursEnd, isNull);
    });

    test('should_map_response_timezone', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me(timezone: 'Asia/Vladivostok'));

      final result = await repo.updateTimezone('Asia/Vladivostok');

      expect((result as Success).value.timezone, 'Asia/Vladivostok');
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me());

      await repo.updateTimezone('Europe/Moscow');

      final captured = verify(() => client.updateMe(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_when_backend_rejects_invalid_iana', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest()));

      final result = await repo.updateTimezone('Not/AZone');

      expect((result as Failure).error, const ApiError.badRequest());
    });

    // Не-UTC таймзона: запись IANA уходит как строка, без какого-либо
    // преобразования к UTC-смещению (фиксируем, что репо не «нормализует» зону).
    test('should_send_non_utc_iana_verbatim', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _me(timezone: 'Asia/Almaty'));

      await repo.updateTimezone('Asia/Almaty');

      final body = verify(() => client.updateMe(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as MeUpdateRequest;
      expect(body.timezone, 'Asia/Almaty');
    });
  });
}
