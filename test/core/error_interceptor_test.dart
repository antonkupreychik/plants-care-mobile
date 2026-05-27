import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/network/error_interceptor.dart';

class _MockHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  setUpAll(
    () => registerFallbackValue(
      DioException(requestOptions: RequestOptions()),
    ),
  );

  late ErrorInterceptor interceptor;
  late _MockHandler handler;

  setUp(() {
    interceptor = ErrorInterceptor();
    handler = _MockHandler();
  });

  ApiError mapErr(DioException err) {
    interceptor.onError(err, handler);
    final captured = verify(() => handler.reject(captureAny())).captured.single
        as DioException;
    return captured.error! as ApiError;
  }

  DioException withBody(int status, Map<String, dynamic> error) {
    final ro = RequestOptions(path: '/x');
    return DioException(
      requestOptions: ro,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: ro,
        statusCode: status,
        data: {'error': error},
      ),
    );
  }

  test('VALIDATION_ERROR → ValidationError с полями', () {
    final r = mapErr(
      withBody(400, {
        'code': 'VALIDATION_ERROR',
        'details': [
          {'field': 'name', 'message': 'must not be blank'},
        ],
      }),
    );
    expect(r, isA<ValidationError>());
    expect((r as ValidationError).details.single.field, 'name');
  });

  test('ACCESS_DENIED / NOT_FOUND / CONFLICT мапятся по коду', () {
    expect(mapErr(withBody(403, {'code': 'ACCESS_DENIED'})),
        isA<AccessDeniedError>());
    expect(mapErr(withBody(404, {'code': 'NOT_FOUND'})), isA<NotFoundError>());
    expect(mapErr(withBody(409, {'code': 'CONFLICT'})), isA<ConflictError>());
  });

  test('таймаут → NetworkError', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.connectionTimeout,
    );
    expect(mapErr(err), isA<NetworkError>());
  });

  test('SocketException (unknown) → NetworkError', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.unknown,
      error: const SocketException('no route'),
    );
    expect(mapErr(err), isA<NetworkError>());
  });

  test('нераспознанное тело → fallback по статусу', () {
    final ro = RequestOptions(path: '/x');
    final err = DioException(
      requestOptions: ro,
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: ro, statusCode: 404, data: 'oops'),
    );
    expect(mapErr(err), isA<NotFoundError>());
  });
}
