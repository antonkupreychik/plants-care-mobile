import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/auth_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/refresh_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/token_pair_response.dart';
import 'package:plantcare_mobile/core/auth/jwt_auth_session.dart';
import 'package:plantcare_mobile/core/auth/token_store.dart';
import 'package:plantcare_mobile/core/network/refresh_interceptor.dart';

class _MockAuthClient extends Mock implements AuthClient {}

class _MockDio extends Mock implements Dio {}

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

TokenPairResponse _pair(String access, String refresh) => TokenPairResponse(
      accessToken: access,
      refreshToken: refresh,
      expiresIn: 900,
      tokenType: 'Bearer',
    );

DioException _err({
  required int? status,
  String path = '/api/v1/plants',
  Map<String, dynamic>? extra,
}) {
  final options = RequestOptions(path: path, extra: extra ?? {});
  return DioException(
    requestOptions: options,
    response: status == null
        ? null
        : Response<dynamic>(requestOptions: options, statusCode: status),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(const RefreshRequest(refreshToken: 'x'));
    registerFallbackValue(
        Response<dynamic>(requestOptions: RequestOptions(path: '/')));
    registerFallbackValue(
        DioException(requestOptions: RequestOptions(path: '/')));
  });

  late _MockAuthClient refreshClient;
  late _MockDio retryDio;
  late _MockSecureStorage storage;
  late TokenStore store;
  late JwtAuthSession session;
  late _MockErrorHandler handler;

  JwtAuthSession authed() => JwtAuthSession(
        store,
        initial: const AuthTokens(accessToken: 'old-a', refreshToken: 'old-r'),
      );

  RefreshInterceptor build({void Function()? onSessionExpired}) =>
      RefreshInterceptor(
        session: session,
        refreshClient: refreshClient,
        retryDio: retryDio,
        onSessionExpired: onSessionExpired,
      );

  setUp(() {
    refreshClient = _MockAuthClient();
    retryDio = _MockDio();
    storage = _MockSecureStorage();
    store = TokenStore(storage);
    handler = _MockErrorHandler();
    // Стор-операции при ротации/сбросе не должны бросать.
    when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
    when(() => storage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
    session = authed();
  });

  test('не-401 → пробрасывается дальше, refresh не вызывается', () async {
    final interceptor = build();
    final err = _err(status: 500);

    interceptor.onError(err, handler);
    await untilCalled(() => handler.next(any()));

    verify(() => handler.next(err)).called(1);
    verifyNever(() => refreshClient.refreshTokens(
        body: any(named: 'body'), extras: any(named: 'extras')));
  });

  test('401 на /auth/** не рефрешим — это отказ входа/ротации', () async {
    final interceptor = build();
    final err = _err(status: 401, path: '/api/v1/auth/refresh');

    interceptor.onError(err, handler);
    await untilCalled(() => handler.next(any()));

    verify(() => handler.next(err)).called(1);
    verifyNever(() => refreshClient.refreshTokens(
        body: any(named: 'body'), extras: any(named: 'extras')));
  });

  test('уже повторённый запрос (extra retried) второй раз не рефрешим',
      () async {
    final interceptor = build();
    final err = _err(status: 401, extra: {'authRetried': true});

    interceptor.onError(err, handler);
    await untilCalled(() => handler.next(any()));

    verify(() => handler.next(err)).called(1);
    verifyNever(() => refreshClient.refreshTokens(
        body: any(named: 'body'), extras: any(named: 'extras')));
  });

  test('без refresh-токена (не аутентифицированы) → не рефрешим', () async {
    session = JwtAuthSession(store); // initial == null
    final interceptor = build();
    final err = _err(status: 401);

    interceptor.onError(err, handler);
    await untilCalled(() => handler.next(any()));

    verify(() => handler.next(err)).called(1);
    verifyNever(() => refreshClient.refreshTokens(
        body: any(named: 'body'), extras: any(named: 'extras')));
  });

  test('401 → ротация, новая пара сохранена, запрос повторён и зарезолвлен',
      () async {
    when(() => refreshClient.refreshTokens(
            body: any(named: 'body'), extras: any(named: 'extras')))
        .thenAnswer((_) async => _pair('new-a', 'new-r'));
    final retried = Response<dynamic>(
      requestOptions: RequestOptions(path: '/api/v1/plants'),
      statusCode: 200,
    );
    when(() => retryDio.fetch<dynamic>(any()))
        .thenAnswer((_) async => retried);

    final interceptor = build();
    final err = _err(status: 401);

    interceptor.onError(err, handler);
    await untilCalled(() => handler.resolve(any()));

    // Refresh ровно один раз, с текущим refresh-токеном.
    final captured = verify(() => refreshClient.refreshTokens(
            body: captureAny(named: 'body'), extras: any(named: 'extras')))
        .captured
        .single as RefreshRequest;
    expect(captured.refreshToken, 'old-r');

    // Новая пара осела в сессии (память) и ушла в стор (персист).
    expect(session.refreshToken, 'new-r');
    verify(() => storage.write(key: any(named: 'key'), value: 'new-a'))
        .called(1);
    verify(() => storage.write(key: any(named: 'key'), value: 'new-r'))
        .called(1);

    // Повтор помечен retried-флагом и зарезолвлен исходному вызывающему.
    final retryOpts =
        verify(() => retryDio.fetch<dynamic>(captureAny())).captured.single
            as RequestOptions;
    expect(retryOpts.extra['authRetried'], isTrue);
    verify(() => handler.resolve(retried)).called(1);
    verifyNever(() => handler.next(any()));
  });

  test('refresh отклонён → сессия очищена, onSessionExpired, ошибка наружу',
      () async {
    when(() => refreshClient.refreshTokens(
            body: any(named: 'body'), extras: any(named: 'extras')))
        .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/api/v1/auth/refresh'),
            response: Response<dynamic>(
                requestOptions: RequestOptions(path: '/'), statusCode: 401)));

    var expiredCalls = 0;
    final interceptor = build(onSessionExpired: () => expiredCalls++);
    final err = _err(status: 401);

    interceptor.onError(err, handler);
    await untilCalled(() => handler.next(any()));

    expect(session.isAuthenticated, isFalse);
    expect(expiredCalls, 1);
    verify(() => storage.delete(key: any(named: 'key'))).called(2);
    verify(() => handler.next(err)).called(1);
    verifyNever(() => retryDio.fetch<dynamic>(any()));
  });

  test('параллельные 401 коллапсируют в один refresh (single-flight)',
      () async {
    final gate = Completer<TokenPairResponse>();
    when(() => refreshClient.refreshTokens(
            body: any(named: 'body'), extras: any(named: 'extras')))
        .thenAnswer((_) => gate.future);
    when(() => retryDio.fetch<dynamic>(any())).thenAnswer((_) async =>
        Response<dynamic>(
            requestOptions: RequestOptions(path: '/'), statusCode: 200));

    final interceptor = build();
    final h1 = _MockErrorHandler();
    final h2 = _MockErrorHandler();

    // Два конкурентных 401 до завершения ротации.
    interceptor.onError(_err(status: 401, path: '/api/v1/plants'), h1);
    interceptor.onError(_err(status: 401, path: '/api/v1/today'), h2);
    await Future<void>.delayed(Duration.zero);

    gate.complete(_pair('new-a', 'new-r'));
    await untilCalled(() => h1.resolve(any()));
    await untilCalled(() => h2.resolve(any()));

    // Обмен токена выполнен ровно один раз на оба запроса.
    verify(() => refreshClient.refreshTokens(
        body: any(named: 'body'),
        extras: any(named: 'extras'))).called(1);
  });
}
