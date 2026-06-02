import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/auth_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/apple_auth_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/google_auth_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/token_pair_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/auth/auth_status_notifier.dart';
import 'package:plantcare_mobile/core/auth/jwt_auth_session.dart';
import 'package:plantcare_mobile/core/auth/token_store.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:plantcare_mobile/features/auth/domain/social_auth_outcome.dart';
import 'package:plantcare_mobile/features/auth/domain/social_sign_in.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockAuthClient extends Mock implements AuthClient {}

class _MockSocialSignIn extends Mock implements SocialSignIn {}

/// In-memory персист пары: пишем/читаем честно (не мок БД), чтобы проверить,
/// что соц-вход реально поднимает сессию.
class _FakeStorage {
  final Map<String, String> _data = {};

  Future<void> write(AuthTokens tokens) async {
    _data['access'] = tokens.accessToken;
    _data['refresh'] = tokens.refreshToken;
  }

  Future<void> clear() async => _data.clear();

  bool get isEmpty => _data.isEmpty;
}

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
      requestOptions: RequestOptions(path: '/api/v1/auth/google'),
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
    registerFallbackValue(const GoogleAuthRequest(idToken: 't'));
    registerFallbackValue(const AppleAuthRequest(identityToken: 't'));
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

  group('signInWithGoogle', () {
    test(
        'should_raise_session_and_return_success_and_pass_id_token_when_backend_ok',
        () async {
      when(() => social.googleIdToken())
          .thenAnswer((_) async => 'google-id-token');
      when(() => auth.authGoogle(body: any(named: 'body')))
          .thenAnswer((_) async => _pair);

      final outcome = await repo.signInWithGoogle();

      expect(outcome, isA<SocialAuthSuccess>());
      // Сессия реально поднята: refresh в памяти сессии + персист + флаг гарда.
      expect(session.refreshToken, 'refresh-456');
      expect(session.isAuthenticated, isTrue);
      expect(storage.isEmpty, isFalse);
      expect(status.isAuthenticated, isTrue);
      // Токен провайдера ушёл в тело запроса (не хардкодится).
      final body = verify(() => auth.authGoogle(
            body: captureAny(named: 'body'),
          )).captured.single as GoogleAuthRequest;
      expect(body.idToken, 'google-id-token');
    });

    test(
        'should_return_cancelled_and_not_call_backend_when_gateway_returns_null',
        () async {
      when(() => social.googleIdToken()).thenAnswer((_) async => null);

      final outcome = await repo.signInWithGoogle();

      expect(outcome, isA<SocialAuthCancelled>());
      // Отмена: бэкенд не зван, токены/статус не тронуты.
      verifyNever(() => auth.authGoogle(body: any(named: 'body')));
      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });

    test(
        'should_return_failure_with_ApiError_and_leave_session_untouched_when_backend_throws',
        () async {
      when(() => social.googleIdToken())
          .thenAnswer((_) async => 'google-id-token');
      when(() => auth.authGoogle(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.network()));

      final outcome = await repo.signInWithGoogle();

      expect(outcome, isA<SocialAuthFailure>());
      expect((outcome as SocialAuthFailure).error, const ApiError.network());
      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });

    test(
        'should_return_failure_and_not_call_backend_when_gateway_throws',
        () async {
      when(() => social.googleIdToken()).thenThrow(StateError('sdk misconfig'));

      final outcome = await repo.signInWithGoogle();

      expect(outcome, isA<SocialAuthFailure>());
      verifyNever(() => auth.authGoogle(body: any(named: 'body')));
      expect(session.isAuthenticated, isFalse);
      expect(status.isAuthenticated, isFalse);
    });
  });

  group('signInWithApple', () {
    test(
        'should_raise_session_and_return_success_and_pass_identity_token_when_backend_ok',
        () async {
      when(() => social.appleIdentityToken())
          .thenAnswer((_) async => 'apple-identity-token');
      when(() => auth.authApple(body: any(named: 'body')))
          .thenAnswer((_) async => _pair);

      final outcome = await repo.signInWithApple();

      expect(outcome, isA<SocialAuthSuccess>());
      expect(session.refreshToken, 'refresh-456');
      expect(session.isAuthenticated, isTrue);
      expect(storage.isEmpty, isFalse);
      expect(status.isAuthenticated, isTrue);
      final body = verify(() => auth.authApple(
            body: captureAny(named: 'body'),
          )).captured.single as AppleAuthRequest;
      expect(body.identityToken, 'apple-identity-token');
    });

    test(
        'should_return_cancelled_and_not_call_backend_when_gateway_returns_null',
        () async {
      when(() => social.appleIdentityToken()).thenAnswer((_) async => null);

      final outcome = await repo.signInWithApple();

      expect(outcome, isA<SocialAuthCancelled>());
      verifyNever(() => auth.authApple(body: any(named: 'body')));
      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });

    test(
        'should_return_failure_with_ApiError_and_leave_session_untouched_when_backend_throws',
        () async {
      when(() => social.appleIdentityToken())
          .thenAnswer((_) async => 'apple-identity-token');
      when(() => auth.authApple(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.badRequest(message: 'bad')));

      final outcome = await repo.signInWithApple();

      expect(outcome, isA<SocialAuthFailure>());
      expect((outcome as SocialAuthFailure).error,
          const ApiError.badRequest(message: 'bad'));
      expect(session.isAuthenticated, isFalse);
      expect(storage.isEmpty, isTrue);
      expect(status.isAuthenticated, isFalse);
    });

    test(
        'should_return_failure_and_not_call_backend_when_gateway_throws',
        () async {
      when(() => social.appleIdentityToken())
          .thenThrow(StateError('sdk misconfig'));

      final outcome = await repo.signInWithApple();

      expect(outcome, isA<SocialAuthFailure>());
      verifyNever(() => auth.authApple(body: any(named: 'body')));
      expect(session.isAuthenticated, isFalse);
      expect(status.isAuthenticated, isFalse);
    });
  });
}
