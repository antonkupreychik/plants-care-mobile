import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/calendar_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/calendar_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/schedule/data/schedule_repository_impl.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockCalendarClient extends Mock implements CalendarClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/calendar'),
      error: error,
    );

void main() {
  setUpAll(() => registerFallbackValue(DateTime(2026, 5, 18)));

  late _MockApi api;
  late _MockCalendarClient calendar;
  late ScheduleRepositoryImpl repo;

  // Понедельник 18 мая 2026.
  final weekStart = DateTime(2026, 5, 18);

  setUp(() {
    api = _MockApi();
    calendar = _MockCalendarClient();
    when(() => api.calendar).thenReturn(calendar);
    repo = ScheduleRepositoryImpl(api);
  });

  void stubSuccess([CalendarResponse? response]) {
    when(() => calendar.getCalendar(
          xChatId: any(named: 'xChatId'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          extras: any(named: 'extras'),
        )).thenAnswer((_) async => response ?? const <String, List<TaskDto>>{});
  }

  group('getWeek success', () {
    test('should_return_success_with_mapped_seven_day_week', () async {
      stubSuccess({
        '2026-05-18': [
          TaskDto(
            scheduleId: 1,
            plantId: 1,
            plantName: 'Monstera',
            taskType: 'WATERING',
            nextDueAt: DateTime.utc(2026, 5, 18, 9),
          ),
        ],
      });

      final result = await repo.getWeek(weekStart: weekStart);

      final week = (result as Success).value;
      expect(week.days, hasLength(7));
      expect(week.days.first.tasks.single.type, CareTaskType.watering);
    });

    test('should_request_monday_and_sunday_as_from_and_to', () async {
      stubSuccess();

      await repo.getWeek(weekStart: weekStart);

      final captured = verify(() => calendar.getCalendar(
            xChatId: any(named: 'xChatId'),
            from: captureAny(named: 'from'),
            to: captureAny(named: 'to'),
            extras: any(named: 'extras'),
          )).captured;
      final from = captured[0] as DateTime;
      final to = captured[1] as DateTime;
      // from = понедельник, to = воскресенье (Пн + 6 дней).
      expect(from, DateTime(2026, 5, 18));
      expect(to, DateTime(2026, 5, 24));
      expect(from.weekday, DateTime.monday);
      expect(to.weekday, DateTime.sunday);
    });

    test('should_send_chat_authScope_and_dateOnly_flag_in_extras', () async {
      // Тест auth-слота: identity не хардкодится — проверяем именно scope-extra
      // (заголовок X-Chat-Id ставит интерсептор). Плюс флаг date-only обхода
      // бага сериализации даты.
      stubSuccess();

      await repo.getWeek(weekStart: weekStart);

      final extras = verify(() => calendar.getCalendar(
            xChatId: any(named: 'xChatId'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;

      // Auth-слот: chat scope.
      expect(extras[kAuthScopeExtraKey], AuthScope.chat);
      // Date-only флаг: ключи from/to помечены для DateQueryInterceptor.
      final dateKeys = extras[kDateOnlyQueryKeysExtraKey];
      expect(dateKeys, isA<Set<String>>());
      expect((dateKeys as Set).containsAll({'from', 'to'}), isTrue);
    });
  });

  group('getWeek failure', () {
    test('should_return_failure_with_ApiError_from_DioException', () async {
      when(() => calendar.getCalendar(
            xChatId: any(named: 'xChatId'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getWeek(weekStart: weekStart);

      expect(result, isA<Failure>());
      expect((result as Failure).error, const ApiError.network());
    });

    test('should_not_rethrow_DioException_to_caller', () async {
      when(() => calendar.getCalendar(
            xChatId: any(named: 'xChatId'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.accessDenied()));

      // Не должно бросить наружу — возвращает Result.failure.
      final result = await repo.getWeek(weekStart: weekStart);

      expect((result as Failure).error, const ApiError.accessDenied());
    });

    test('should_fallback_to_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => calendar.getCalendar(
            xChatId: any(named: 'xChatId'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith('plain string'));

      final result = await repo.getWeek(weekStart: weekStart);

      expect((result as Failure).error, const ApiError.unknown());
    });
  });
}
