import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/auth_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/email_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/logout_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/magic_link_verify_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/token_pair_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/auth/auth_status_notifier.dart';
import 'package:plantcare_mobile/core/auth/jwt_auth_session.dart';
import 'package:plantcare_mobile/core/auth/token_store.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:plantcare_mobile/features/auth/domain/social_sign_in.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockAuthClient extends Mock implements AuthClient {}

class _MockSocialSignIn extends Mock implements SocialSignIn {}

/// Учётная in-memory реализация [TokenStore] — пишем/читаем честно (не мок БД),
/// чтобы проверить, что сессия реально персистит пару.
class _FakeStorage {
  final Map<String, String> _data = {};

  Future<void> write(AuthTokens tokens) async {
    _data['access'] = tokens.accessToken;
    _data['refresh'] = tokens.refreshToken;
  }

  Future<void> clear() async => _data.clear();

  bool get isEmpty => _data.isEmpty;
}

/// Облегчённый [TokenStore] поверх [_FakeStorage] (FlutterSecureStorage в тестах
/// недоступен) — реализует тот же контракт write/clear.
class _FakeTokenStore implements TokenStore {
  _FakeTokenStore(this.storage);

  final _FakeStorage storage;

  @override
  Future<AuthTokens?> read() async => null;

  @override
  Future<void> write(AuthTokens tokens) => storage.write(tokens);

  @override
  Future<void> clear() => storage.clear();
}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/auth/email/request'),
      error: error,
    );

const _pair = TokenPairResponse(
  accessToken: 'access-123',
  refreshToken: 'refresh-456',
  expiresIn: 3600,
  tokenType: 'Bearer',
);

void main() {
  setUpAll(() {
    registerFallbackValue(const EmailRequest(email: 'x@y.z'));
    registerFallbackValue(const MagicLinkVerifyRequest(token: 't'));
    registerFallbackValue(const LogoutRequest(refreshToken: 'r'));
  });

  late _MockApi api;
  late _MockAuthClient auth;
  late _MockSocialSignIn social;
  late _FakeStorage storage;
  late JwtAuthSession session;
  late AuthStatusNotifier status;
  late AuthRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    auth = _MockAuthClient();
    social = _MockSocialSignIn();
    storage = _FakeStorage();
    session = JwtAuthSession(_FakeTokenStore(storage));
    status = AuthStatusNotifier(false);
    when(() => api.auth).thenReturn(auth);
    repo = AuthRepositoryImpl(api, session, status, social);
  });

  group('requestMagicLink', () {
    test('should_return_success_when_client_completes', () async {
      when(() => auth.requestMagicLink(body: any(named: 'body')))
          .thenAnswer((_) async {});

      final result = await repo.requestMagicLink('user@example.com');

      expect(result, isA<Success<void>>());
      // Email из аргумента уходит в тело запроса (идентичность не хардкодится).
      final body = verify(() => auth.requestMagicLink(
            body: captureAny(named: 'body'),
          )).captured.single as EmailRequest;
      expect(body.email, 'user@example.com');
    });

    test('should_return_failure_with_ApiError_when_DioException_carries_it',
        () async {
      when(() => auth.requestMagicLink(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.requestMagicLink('user@example.com');

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => auth.requestMagicLink(body: any(named: 'body')))
          .thenThrow(_dioWith('plain string'));

      final result = await repo.requestMagicLink('user@example.com');

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('verifyMagicLink', () {
    test(
        'should_persist_token_pair_and_raise_auth_flag_and_return_success_on_ok',
        () async {
      when(() => auth.verifyMagicLink(body: any(named: 'body')))
          .thenAnswer((_) async => _pair);

      final result = await repo.verifyMagicLink('opaque-token');

      expect(result, isA<Success<void>>());
      // Сессия поднята: refresh сохранён в памяти сессии…
      expect(session.refreshToken, 'refresh-456');
      expect(session.isAuthenticated, isTrue);
      // …и записан в персист (честный store, не мок).
      expect(storage.isEmpty, isFalse);
      // …и реактивный флаг для router-guard поднят.
      expect(status.isAuthenticated, isTrue);
      // Токен из ссылки ушёл в тело verify-запроса.
      final body = verify(() => auth.verifyMagicLink(
            body: captureAny(named: 'body'),
          )).captured.single as MagicLinkVerifyRequest;
      expect(body.token, 'opaque-token');
    });

    test(
        'should_return_failure_and_leave_session_untouched_when_verify_fails',
        () async {
      when(() => auth.verifyMagicLink(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.badRequest(message: 'expired')));

      final result = await repo.verifyMagicLink('dead-token');

      expect((result as Failure).error,
          const ApiError.badRequest(message: 'expired'));
      // Токены не тронуты, флаг остался опущенным.
      expect(session.refreshToken, isNull);
      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });
  });

  group('signOut', () {
    test('should_revoke_refresh_then_clear_session_and_drop_flag', () async {
      // Поднимаем сессию (есть refresh для отзыва).
      await session.updateTokens(
        const AuthTokens(accessToken: 'a', refreshToken: 'r-1'),
      );
      status.set(true);
      when(() => auth.logout(body: any(named: 'body'))).thenAnswer((_) async {});

      await repo.signOut();

      // refresh из сессии ушёл в logout-запрос…
      final body = verify(() => auth.logout(
            body: captureAny(named: 'body'),
          )).captured.single as LogoutRequest;
      expect(body.refreshToken, 'r-1');
      // …сессия погашена локально и флаг опущен.
      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });

    test('should_clear_session_even_when_logout_throws_best_effort', () async {
      await session.updateTokens(
        const AuthTokens(accessToken: 'a', refreshToken: 'r-2'),
      );
      status.set(true);
      // Backend logout кинул — best-effort: наружу НЕ бросаем, чистим локально.
      when(() => auth.logout(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.unknown()));

      await repo.signOut();

      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });

    test('should_skip_logout_call_when_no_refresh_token', () async {
      // Сессия не поднята — отзывать нечего, сетевого вызова быть не должно.
      await repo.signOut();

      verifyNever(() => auth.logout(body: any(named: 'body')));
      expect(session.isAuthenticated, isFalse);
      expect(status.isAuthenticated, isFalse);
    });
  });
}
