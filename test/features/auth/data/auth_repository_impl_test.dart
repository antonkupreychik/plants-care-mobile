import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/auth_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/email_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/guest_login_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/guest_login_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/logout_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/magic_link_verify_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/telegram_start_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/telegram_verify_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/token_pair_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/auth/auth_status_notifier.dart';
import 'package:plantcare_mobile/core/auth/jwt_auth_session.dart';
import 'package:plantcare_mobile/core/auth/token_store.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:plantcare_mobile/features/auth/domain/social_sign_in.dart';
import 'package:plantcare_mobile/features/auth/domain/telegram_login.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockAuthClient extends Mock implements AuthClient {}

class _MockSocialSignIn extends Mock implements SocialSignIn {}

/// In-memory fake для FlutterSecureStorage (нет Keychain/Keystore в unit-тестах).
class _FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _data[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _data.remove(key);

  bool hasKey(String key) => _data.containsKey(key);
  String? operator [](String key) => _data[key];
}

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

/// [TokenStore] симулирующий ошибку хранилища на [clear] — для тестирования
/// поведения signOut, когда FlutterSecureStorage падает (напр. некоторые Android).
class _ThrowingTokenStore implements TokenStore {
  @override
  Future<AuthTokens?> read() async => null;

  @override
  Future<void> write(AuthTokens tokens) async {}

  @override
  Future<void> clear() async =>
      throw StateError('FlutterSecureStorage unavailable');
}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/auth/email/request'),
      error: error,
    );

/// DioException, имитирующий ответ backend `{error:{code}}` + HTTP-статус,
/// как после `ErrorInterceptor` (он кладёт ApiError в .error, но тело с сырым
/// `code` остаётся на response — репозиторий читает его для telegram-ветвей).
DioException _dioWithCode(String code, int status, ApiError apiError) {
  final req = RequestOptions(path: '/api/v1/auth/telegram/verify');
  return DioException(
    requestOptions: req,
    error: apiError,
    response: Response<dynamic>(
      requestOptions: req,
      statusCode: status,
      data: {
        'error': {'code': code, 'message': 'x'},
      },
    ),
  );
}

const _pair = TokenPairResponse(
  accessToken: 'access-123',
  refreshToken: 'refresh-456',
  expiresIn: 3600,
  tokenType: 'Bearer',
);

const _guestPair = GuestLoginResponse(
  accessToken: 'guest-access-123',
  refreshToken: 'guest-refresh-456',
  expiresIn: 3600,
  tokenType: 'Bearer',
  isNewUser: true,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const EmailRequest(email: 'x@y.z'));
    registerFallbackValue(const MagicLinkVerifyRequest(token: 't'));
    registerFallbackValue(const LogoutRequest(refreshToken: 'r'));
    registerFallbackValue(const GuestLoginRequest(deviceId: 'test-device-id'));
    registerFallbackValue(
        const TelegramVerifyRequest(sessionId: 's', code: 'c'));
  });

  late _MockApi api;
  late _MockAuthClient auth;
  late _MockSocialSignIn social;
  late _FakeStorage storage;
  late _FakeSecureStorage secureStorage;
  late JwtAuthSession session;
  late AuthStatusNotifier status;
  late AuthRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    auth = _MockAuthClient();
    social = _MockSocialSignIn();
    storage = _FakeStorage();
    secureStorage = _FakeSecureStorage();
    session = JwtAuthSession(_FakeTokenStore(storage));
    status = AuthStatusNotifier(false);
    when(() => api.auth).thenReturn(auth);
    repo = AuthRepositoryImpl(api, session, status, social, secureStorage);
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

    test(
        'should_drop_auth_flag_even_when_session_clear_throws_storage_error',
        () async {
      // Симулируем ошибку secure-storage (напр. некоторые Android-версии):
      // _session.clear() бросает, но _status.set(false) обязан произойти —
      // иначе router-guard не сработает и logout «ничего не делает» в UI.
      final throwingSession = JwtAuthSession(
        _ThrowingTokenStore(),
        initial: const AuthTokens(accessToken: 'a', refreshToken: 'r-throw'),
      );
      final throwingStatus = AuthStatusNotifier(true);
      final throwingRepo = AuthRepositoryImpl(
        api,
        throwingSession,
        throwingStatus,
        social,
        secureStorage,
      );
      when(() => auth.logout(body: any(named: 'body'))).thenAnswer((_) async {});

      // signOut НЕ должен бросать наружу, а auth-флаг обязан быть сброшен.
      await expectLater(throwingRepo.signOut(), completes);
      expect(throwingStatus.isAuthenticated, isFalse);
    });
  });

  group('signInAsGuest', () {
    test(
        'should_generate_deviceId_save_to_storage_call_endpoint_and_raise_session',
        () async {
      when(() => auth.guestLogin(body: any(named: 'body')))
          .thenAnswer((_) async => _guestPair);

      final result = await repo.signInAsGuest();

      expect(result, isA<Success<void>>());
      // deviceId был сохранён в secure storage.
      expect(secureStorage.hasKey('guest_device_id'), isTrue);
      final savedDeviceId = secureStorage['guest_device_id']!;
      // UUID v4 формат: 8-4-4-4-12 hex-символов.
      expect(savedDeviceId, matches(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'));
      // Сессия поднята.
      expect(session.isAuthenticated, isTrue);
      expect(status.isAuthenticated, isTrue);
      // deviceId уйдёт в запрос.
      final body = verify(() => auth.guestLogin(
            body: captureAny(named: 'body'),
          )).captured.single as GuestLoginRequest;
      expect(body.deviceId, savedDeviceId);
    });

    test(
        'should_reuse_existing_deviceId_on_repeated_call_and_not_generate_new',
        () async {
      when(() => auth.guestLogin(body: any(named: 'body')))
          .thenAnswer((_) async => _guestPair);

      // Первый вызов генерирует deviceId.
      await repo.signInAsGuest();
      final firstDeviceId = secureStorage['guest_device_id'];

      // Второй вызов должен использовать тот же deviceId.
      await repo.signInAsGuest();
      final secondDeviceId = secureStorage['guest_device_id'];

      expect(firstDeviceId, isNotNull);
      expect(secondDeviceId, equals(firstDeviceId));
      // Эндпоинт вызывался дважды с одинаковым deviceId.
      final captured = verify(() => auth.guestLogin(
            body: captureAny(named: 'body'),
          )).captured;
      expect(captured.length, 2);
      final first = (captured[0] as GuestLoginRequest).deviceId;
      final second = (captured[1] as GuestLoginRequest).deviceId;
      expect(first, equals(second));
    });

    test('should_return_failure_when_backend_returns_error', () async {
      when(() => auth.guestLogin(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.signInAsGuest();

      expect((result as Failure).error, const ApiError.network());
      expect(session.isAuthenticated, isFalse);
    });
  });

  group('startTelegramLogin', () {
    const startRes = TelegramStartResponse(
      sessionId: 'sess-1',
      deepLink: 'https://t.me/Bot?start=auth_sess-1',
      codeLength: 6,
      resendAfterSec: 45,
    );

    test('should_map_response_to_session_on_success', () async {
      when(() => auth.authTelegramStart(body: any(named: 'body')))
          .thenAnswer((_) async => startRes);

      final result = await repo.startTelegramLogin();

      final telegramSession = (result as Success<TelegramStartSession>).value;
      expect(telegramSession.sessionId, 'sess-1');
      expect(telegramSession.deepLink, startRes.deepLink);
      expect(telegramSession.codeLength, 6);
      expect(telegramSession.resendAfterSec, 45);
    });

    test('should_return_failure_on_dio_error', () async {
      when(() => auth.authTelegramStart(body: any(named: 'body')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.startTelegramLogin();

      expect((result as Failure).error, const ApiError.network());
    });
  });

  group('verifyTelegramLogin', () {
    void stubVerifyThrow(DioException e) {
      when(() => auth.authTelegramVerify(body: any(named: 'body')))
          .thenThrow(e);
    }

    test('should_raise_session_and_return_success', () async {
      when(() => auth.authTelegramVerify(body: any(named: 'body')))
          .thenAnswer((_) async => _pair);

      final outcome =
          await repo.verifyTelegramLogin(sessionId: 's', code: '123456');

      expect(outcome, isA<TelegramVerifySuccess>());
      expect(session.isAuthenticated, isTrue);
      expect(status.isAuthenticated, isTrue);
      // sessionId/code уходят в тело (идентичность не хардкодится).
      final body = verify(() => auth.authTelegramVerify(
            body: captureAny(named: 'body'),
          )).captured.single as TelegramVerifyRequest;
      expect(body.sessionId, 's');
      expect(body.code, '123456');
    });

    test('should_map_invalid_code_to_TelegramInvalidCode', () async {
      stubVerifyThrow(
          _dioWithCode('invalid_code', 401, const ApiError.unauthorized()));

      final outcome =
          await repo.verifyTelegramLogin(sessionId: 's', code: '000000');

      expect(outcome, isA<TelegramInvalidCode>());
      expect(session.isAuthenticated, isFalse);
    });

    test('should_map_session_expired_to_TelegramSessionExpired', () async {
      stubVerifyThrow(
          _dioWithCode('session_expired', 410, const ApiError.unknown()));

      final outcome =
          await repo.verifyTelegramLogin(sessionId: 's', code: '000000');

      expect(outcome, isA<TelegramSessionExpired>());
    });

    test('should_map_too_many_attempts_to_TelegramTooManyAttempts', () async {
      stubVerifyThrow(
          _dioWithCode('too_many_attempts', 429, const ApiError.unknown()));

      final outcome =
          await repo.verifyTelegramLogin(sessionId: 's', code: '000000');

      expect(outcome, isA<TelegramTooManyAttempts>());
    });

    test('should_map_user_not_found_to_TelegramUserNotFound', () async {
      stubVerifyThrow(_dioWithCode(
          'telegram_user_not_found', 404, const ApiError.notFound()));

      final outcome =
          await repo.verifyTelegramLogin(sessionId: 's', code: '000000');

      expect(outcome, isA<TelegramUserNotFound>());
    });

    test('should_map_unrecognised_error_to_TelegramVerifyFailure', () async {
      stubVerifyThrow(_dioWith(const ApiError.network()));

      final outcome =
          await repo.verifyTelegramLogin(sessionId: 's', code: '000000');

      expect(outcome, isA<TelegramVerifyFailure>());
      expect((outcome as TelegramVerifyFailure).error, const ApiError.network());
    });
  });
}
