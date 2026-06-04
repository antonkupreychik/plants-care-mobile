import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/auth/auth_session.dart';
import 'package:plantcare_mobile/core/network/auth_interceptor.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';

class _StubSession implements AuthSession {
  @override
  Map<String, String> headersFor(AuthScope scope) => switch (scope) {
        AuthScope.user || AuthScope.chat => const {'Authorization': 'Bearer t'},
        AuthScope.none => const {},
      };

  @override
  bool get isAuthenticated => true;
}

class _MockHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  setUpAll(() => registerFallbackValue(RequestOptions()));

  late AuthInterceptor interceptor;
  late _MockHandler handler;

  setUp(() {
    interceptor = AuthInterceptor(_StubSession());
    handler = _MockHandler();
  });

  RequestOptions runWith(AuthScope? scope) {
    final options = RequestOptions(
      path: '/x',
      extra: scope == null ? {} : {kAuthScopeExtraKey: scope},
    );
    interceptor.onRequest(options, handler);
    final captured =
        verify(() => handler.next(captureAny())).captured.single;
    return captured as RequestOptions;
  }

  test('chat scope → заголовок Authorization: Bearer проставлен', () {
    expect(runWith(AuthScope.chat).headers['Authorization'], 'Bearer t');
  });

  test('user scope → заголовок Authorization: Bearer проставлен', () {
    expect(runWith(AuthScope.user).headers['Authorization'], 'Bearer t');
  });

  test('без scope в extra → дефолт none, заголовка авторизации нет', () {
    final headers = runWith(null).headers;
    expect(headers.containsKey('Authorization'), isFalse);
  });
}
