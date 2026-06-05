import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/vacation_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/vacation_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/vacation_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/vacation/data/vacation_repository_impl.dart';
import 'package:plantcare_mobile/features/vacation/domain/vacation_range.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockVacationClient extends Mock implements VacationClient {}

class _FakeVacationRequest extends Fake implements VacationRequest {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/vacation'),
      error: error,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeVacationRequest());
  });

  late _MockApi api;
  late _MockVacationClient client;
  late VacationRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    client = _MockVacationClient();
    when(() => api.vacation).thenReturn(client);
    repo = VacationRepositoryImpl(api);
  });

  group('getStatus', () {
    test('should_map_response_to_status', () async {
      when(() => client.getVacation(extras: any(named: 'extras'))).thenAnswer(
        (_) async => VacationResponse(
          active: true,
          pausedUntil: DateTime.utc(2026, 6, 14, 20, 59, 59),
        ),
      );

      final result = await repo.getStatus();

      final status = (result as Success).value;
      expect(status.active, isTrue);
      expect(status.pausedUntil, DateTime.utc(2026, 6, 14, 20, 59, 59));
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.getVacation(extras: any(named: 'extras')))
          .thenAnswer((_) async => const VacationResponse(active: false));

      await repo.getStatus();

      final captured = verify(() => client.getVacation(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_with_ApiError_from_DioException', () async {
      when(() => client.getVacation(extras: any(named: 'extras')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getStatus();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_unknown_when_error_not_ApiError', () async {
      when(() => client.getVacation(extras: any(named: 'extras')))
          .thenThrow(_dioWith('boom'));

      final result = await repo.getStatus();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('start', () {
    final range = VacationRange(
      from: DateTime(2026, 6, 1),
      to: DateTime(2026, 6, 14),
    );

    test('should_send_range_in_body', () async {
      when(() => client.startVacation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const VacationResponse(active: true));

      await repo.start(range);

      final body = verify(() => client.startVacation(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as VacationRequest;
      expect(body.from, DateTime(2026, 6, 1));
      expect(body.to, DateTime(2026, 6, 14));
    });

    // Воркэраунд кодгена `format: date`: репо помечает поля тела `from`/`to`
    // через dateOnlyBodyExtra → DateQueryInterceptor усечёт ISO до YYYY-MM-DD.
    test('should_mark_date_only_body_keys_for_from_and_to', () async {
      when(() => client.startVacation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => const VacationResponse(active: true));

      await repo.start(range);

      final extras = verify(() => client.startVacation(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(extras[kAuthScopeExtraKey], AuthScope.user);
      expect(extras[kDateOnlyBodyKeysExtraKey], {'from', 'to'});
    });

    test('should_map_response_to_status', () async {
      when(() => client.startVacation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer(
        (_) async => VacationResponse(
          active: true,
          pausedUntil: DateTime.utc(2026, 6, 14, 20, 59, 59),
        ),
      );

      final result = await repo.start(range);

      expect((result as Success).value.active, isTrue);
    });

    test('should_return_failure_when_backend_rejects_range', () async {
      when(() => client.startVacation(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest()));

      final result = await repo.start(range);

      expect((result as Failure).error, const ApiError.badRequest());
    });
  });

  group('end', () {
    test('should_return_inactive_status_on_success', () async {
      when(() => client.endVacation(extras: any(named: 'extras')))
          .thenAnswer((_) async {});

      final result = await repo.end();

      final status = (result as Success).value;
      expect(status.active, isFalse);
      expect(status.pausedUntil, isNull);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => client.endVacation(extras: any(named: 'extras')))
          .thenAnswer((_) async {});

      await repo.end();

      final captured = verify(() => client.endVacation(
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_on_DioException', () async {
      when(() => client.endVacation(extras: any(named: 'extras')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.end();

      expect((result as Failure).error, const ApiError.network());
    });
  });
}
