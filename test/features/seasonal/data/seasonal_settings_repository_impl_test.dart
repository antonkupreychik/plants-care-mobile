import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/me_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_locale.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_response_seasonal_mode.dart';
import 'package:plantcare_mobile/core/api/generated/models/me_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/season.dart';
import 'package:plantcare_mobile/core/api/generated/models/season_settings.dart';
import 'package:plantcare_mobile/core/api/generated/models/seasonal_settings_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/seasonal_settings_response_mode.dart';
import 'package:plantcare_mobile/core/api/generated/models/seasonal_settings_update_request.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/seasonal/data/seasonal_settings_repository_impl.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_mode.dart';
import 'package:plantcare_mobile/features/seasonal/domain/seasonal_settings.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockMeClient extends Mock implements MeClient {}

class _FakeUpdateRequest extends Fake implements MeUpdateRequest {}

class _FakeSeasonalUpdateRequest extends Fake
    implements SeasonalSettingsUpdateRequest {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/me/seasonal'),
      error: error,
    );

SeasonalSettingsResponse _seasonalResponse({
  bool enabled = true,
  SeasonalSettingsResponseMode mode = SeasonalSettingsResponseMode.multiplier,
  double summerMultiplier = 1.2,
  int? summerInterval,
  double winterMultiplier = 0.7,
  int? winterInterval,
}) =>
    SeasonalSettingsResponse(
      enabled: enabled,
      mode: mode,
      seasons: [
        SeasonSettings(
          season: Season.summer,
          multiplier: summerMultiplier,
          intervalDays: summerInterval,
        ),
        SeasonSettings(
          season: Season.winter,
          multiplier: winterMultiplier,
          intervalDays: winterInterval,
        ),
      ],
    );

MeResponse _meResponse() => MeResponse(
      id: 1,
      emailVerified: true,
      createdAt: DateTime.utc(2026),
      name: 'Test',
      plantsTotal: 0,
      tasksToday: 0,
      totalCareEvents: 0,
      notificationsUnread: 0,
      quietHoursStart: '22:00',
      quietHoursEnd: '08:00',
      timezone: 'Europe/Moscow',
      locale: MeResponseLocale.ru,
      seasonalEnabled: true,
      seasonalMode: MeResponseSeasonalMode.multiplier,
      weatherEnabled: false,
      featureFlags: const {},
      appleLinked: false,
      googleLinked: false,
      emailLinked: false,
      telegramLinked: false,
      isGuest: false,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeUpdateRequest());
    registerFallbackValue(_FakeSeasonalUpdateRequest());
    registerFallbackValue(Season.summer);
  });

  late _MockApi api;
  late _MockMeClient client;
  late SeasonalSettingsRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockMeClient();
    when(() => api.me).thenReturn(client);
    repo = SeasonalSettingsRepositoryImpl(api);
  });

  group('getSettings', () {
    test('should_map_SeasonalSettingsResponse_to_domain', () async {
      when(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .thenAnswer((_) async => _seasonalResponse(
                summerMultiplier: 1.3,
                summerInterval: 7,
                winterMultiplier: 0.6,
              ));

      final result = await repo.getSettings();

      final settings = (result as Success<SeasonalSettings>).value;
      expect(settings.enabled, isTrue);
      expect(settings.mode, SeasonalMode.multiplier);
      expect(settings.summer?.multiplier, 1.3);
      expect(settings.summer?.intervalDays, 7);
      expect(settings.winter?.multiplier, 0.6);
      expect(settings.winter?.intervalDays, isNull);
    });

    // Auth-слот: user-scoped, Bearer ставит AuthInterceptor.
    test('should_send_user_authScope_in_extras', () async {
      when(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .thenAnswer((_) async => _seasonalResponse());

      await repo.getSettings();

      final captured = verify(() => client.getSeasonalSettings(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_on_DioException_with_ApiError', () async {
      when(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getSettings();

      expect((result as Failure<SeasonalSettings>).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .thenThrow(_dioWith('unexpected'));

      final result = await repo.getSettings();

      expect((result as Failure<SeasonalSettings>).error, const ApiError.unknown());
    });
  });

  group('setEnabled', () {
    test('should_patch_me_then_get_seasonal_and_return_domain', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _meResponse());
      when(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .thenAnswer((_) async => _seasonalResponse(enabled: true));

      final result = await repo.setEnabled(true);

      final settings = (result as Success<SeasonalSettings>).value;
      expect(settings.enabled, isTrue);
      // Verify both calls were made.
      verify(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).called(1);
      verify(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .called(1);
    });

    test('should_send_only_seasonalEnabled_in_patch', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _meResponse());
      when(() => client.getSeasonalSettings(extras: any(named: 'extras')))
          .thenAnswer((_) async => _seasonalResponse());

      await repo.setEnabled(false);

      final body = verify(() => client.updateMe(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as MeUpdateRequest;
      expect(body.seasonalEnabled, isFalse);
      // Only seasonalEnabled sent; other fields null (PATCH semantics).
      expect(body.quietHoursStart, isNull);
      expect(body.timezone, isNull);
    });

    test('should_return_failure_when_patch_me_fails', () async {
      when(() => client.updateMe(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.setEnabled(true);

      expect((result as Failure<SeasonalSettings>).error, const ApiError.network());
      // GET /me/seasonal should NOT be called when PATCH fails.
      verifyNever(
        () => client.getSeasonalSettings(extras: any(named: 'extras')),
      );
    });
  });

  group('updateSeason', () {
    test('should_call_updateSeasonalSettings_and_return_domain', () async {
      when(() => client.updateSeasonalSettings(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse(summerMultiplier: 1.5));

      final result = await repo.updateSeason(
        seasonApiValue: 'SUMMER',
        multiplier: 1.5,
      );

      final settings = (result as Success<SeasonalSettings>).value;
      expect(settings.summer?.multiplier, 1.5);
    });

    test('should_send_correct_season_and_multiplier', () async {
      when(() => client.updateSeasonalSettings(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse());

      await repo.updateSeason(seasonApiValue: 'WINTER', multiplier: 0.8);

      final body = verify(() => client.updateSeasonalSettings(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as SeasonalSettingsUpdateRequest;
      expect(body.season, Season.winter);
      expect(body.multiplier, 0.8);
      expect(body.intervalDays, isNull);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.updateSeasonalSettings(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse());

      await repo.updateSeason(seasonApiValue: 'SUMMER', intervalDays: 10);

      final captured = verify(() => client.updateSeasonalSettings(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_on_error', () async {
      when(() => client.updateSeasonalSettings(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest()));

      final result =
          await repo.updateSeason(seasonApiValue: 'SUMMER', multiplier: 2.0);

      expect((result as Failure<SeasonalSettings>).error, const ApiError.badRequest());
    });
  });

  group('resetSeason', () {
    test('should_call_clearSeasonalInterval_and_return_domain', () async {
      when(() => client.clearSeasonalInterval(
            season: any(named: 'season'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse(summerInterval: null));

      final result = await repo.resetSeason(seasonApiValue: 'SUMMER');

      final settings = (result as Success<SeasonalSettings>).value;
      expect(settings.summer?.intervalDays, isNull);
    });

    test('should_pass_summer_season_to_client', () async {
      when(() => client.clearSeasonalInterval(
            season: any(named: 'season'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse());

      await repo.resetSeason(seasonApiValue: 'SUMMER');

      final capturedSeason = verify(() => client.clearSeasonalInterval(
            season: captureAny(named: 'season'),
            extras: any(named: 'extras'),
          )).captured.single as Season;
      expect(capturedSeason, Season.summer);
    });

    test('should_pass_winter_season_to_client', () async {
      when(() => client.clearSeasonalInterval(
            season: any(named: 'season'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse());

      await repo.resetSeason(seasonApiValue: 'WINTER');

      final capturedSeason = verify(() => client.clearSeasonalInterval(
            season: captureAny(named: 'season'),
            extras: any(named: 'extras'),
          )).captured.single as Season;
      expect(capturedSeason, Season.winter);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.clearSeasonalInterval(
            season: any(named: 'season'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _seasonalResponse());

      await repo.resetSeason(seasonApiValue: 'SUMMER');

      final captured = verify(() => client.clearSeasonalInterval(
            season: any(named: 'season'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_on_error', () async {
      when(() => client.clearSeasonalInterval(
            season: any(named: 'season'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.resetSeason(seasonApiValue: 'WINTER');

      expect((result as Failure<SeasonalSettings>).error, const ApiError.network());
    });
  });
}
