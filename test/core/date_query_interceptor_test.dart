import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/network/date_query_interceptor.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';

class _MockHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  setUpAll(() => registerFallbackValue(RequestOptions()));

  late DateQueryInterceptor interceptor;
  late _MockHandler handler;

  setUp(() {
    interceptor = DateQueryInterceptor();
    handler = _MockHandler();
  });

  /// Прогоняет onRequest и возвращает RequestOptions, переданные в handler.next.
  RequestOptions runWith({
    required Map<String, dynamic> queryParameters,
    Map<String, dynamic> extra = const {},
  }) {
    final options = RequestOptions(
      path: '/calendar',
      queryParameters: Map<String, dynamic>.from(queryParameters),
      extra: Map<String, dynamic>.from(extra),
    );
    interceptor.onRequest(options, handler);
    final captured = verify(() => handler.next(captureAny())).captured.single;
    return captured as RequestOptions;
  }

  test('should_truncate_marked_iso_string_params_to_date_only', () {
    // Это и есть фикс реального бага: backend 500 на datetime, 200 на YYYY-MM-DD.
    final result = runWith(
      queryParameters: {
        'from': '2026-05-20T00:00:00.000',
        'to': '2026-05-26T00:00:00.000',
      },
      extra: dateOnlyQueryExtra({'from', 'to'}),
    );

    expect(result.queryParameters['from'], '2026-05-20');
    expect(result.queryParameters['to'], '2026-05-26');
  });

  test('should_not_touch_params_outside_the_marked_set', () {
    final result = runWith(
      queryParameters: {
        'from': '2026-05-20T00:00:00.000',
        'cursor': '2026-05-20T12:34:56.000',
      },
      extra: dateOnlyQueryExtra({'from'}),
    );

    expect(result.queryParameters['from'], '2026-05-20');
    // Не в наборе → не трогаем, даже если по форме похож на дату.
    expect(result.queryParameters['cursor'], '2026-05-20T12:34:56.000');
  });

  test('should_truncate_when_value_is_raw_DateTime', () {
    // Подстраховка на случай, если кодген начнёт класть сырой DateTime.
    final result = runWith(
      queryParameters: {'from': DateTime(2026, 5, 20, 14, 37)},
      extra: dateOnlyQueryExtra({'from'}),
    );

    expect(result.queryParameters['from'], '2026-05-20');
  });

  test('should_leave_query_unchanged_when_extra_absent', () {
    final result = runWith(
      queryParameters: {'from': '2026-05-20T00:00:00.000'},
    );

    // Без extra-метки интерсептор не трогает ничего.
    expect(result.queryParameters['from'], '2026-05-20T00:00:00.000');
  });

  test('should_skip_marked_key_missing_from_query', () {
    final result = runWith(
      queryParameters: {'from': '2026-05-20T00:00:00.000'},
      extra: dateOnlyQueryExtra({'from', 'to'}),
    );

    expect(result.queryParameters['from'], '2026-05-20');
    expect(result.queryParameters.containsKey('to'), isFalse);
  });

  test('should_leave_string_without_T_separator_untouched', () {
    final result = runWith(
      queryParameters: {'from': '2026-05-20'},
      extra: dateOnlyQueryExtra({'from'}),
    );

    expect(result.queryParameters['from'], '2026-05-20');
  });

  group('date-only body fix', () {
    /// Прогоняет onRequest с JSON-телом и возвращает усечённое тело.
    Map<String, dynamic> runBody({
      required Map<String, dynamic> data,
      Map<String, dynamic> extra = const {},
    }) {
      final options = RequestOptions(
        path: '/vacation',
        data: Map<String, dynamic>.from(data),
        extra: Map<String, dynamic>.from(extra),
      );
      interceptor.onRequest(options, handler);
      final captured =
          verify(() => handler.next(captureAny())).captured.single
              as RequestOptions;
      return captured.data as Map<String, dynamic>;
    }

    test('should_truncate_marked_iso_string_body_fields_to_date_only', () {
      // Реальный кейс POST /vacation: from/to уходят как datetime, backend 400.
      final body = runBody(
        data: {
          'from': '2026-06-01T00:00:00.000',
          'to': '2026-06-14T00:00:00.000',
        },
        extra: dateOnlyBodyExtra({'from', 'to'}),
      );

      expect(body['from'], '2026-06-01');
      expect(body['to'], '2026-06-14');
    });

    test('should_not_touch_body_fields_outside_marked_set', () {
      final body = runBody(
        data: {
          'from': '2026-06-01T00:00:00.000',
          'note': '2026-06-01T12:00:00.000',
        },
        extra: dateOnlyBodyExtra({'from'}),
      );

      expect(body['from'], '2026-06-01');
      expect(body['note'], '2026-06-01T12:00:00.000');
    });

    test('should_leave_body_unchanged_when_extra_absent', () {
      final body = runBody(data: {'from': '2026-06-01T00:00:00.000'});

      expect(body['from'], '2026-06-01T00:00:00.000');
    });

    test('should_skip_marked_body_key_missing_from_data', () {
      final body = runBody(
        data: {'from': '2026-06-01T00:00:00.000'},
        extra: dateOnlyBodyExtra({'from', 'to'}),
      );

      expect(body['from'], '2026-06-01');
      expect(body.containsKey('to'), isFalse);
    });
  });
}
