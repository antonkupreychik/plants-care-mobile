import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/generated/models/apple_auth_request.dart';
import '../../../core/api/generated/models/email_request.dart';
import '../../../core/api/generated/models/google_auth_request.dart';
import '../../../core/api/generated/models/guest_convert_request.dart';
import '../../../core/api/generated/models/guest_convert_request_provider.dart';
import '../../../core/api/generated/models/guest_convert_response_status.dart';
import '../../../core/api/generated/models/guest_login_request.dart';
import '../../../core/api/generated/models/logout_request.dart';
import '../../../core/api/generated/models/magic_link_verify_request.dart';
import '../../../core/api/generated/models/token_pair_response.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/auth/auth_status_notifier.dart';
import '../../../core/auth/jwt_auth_session.dart';
import '../../../core/auth/token_store.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../domain/auth_repository.dart';
import '../domain/social_auth_outcome.dart';
import '../domain/social_sign_in.dart';

/// Ключ в [FlutterSecureStorage] для хранения гостевого deviceId.
const _guestDeviceIdKey = 'guest_device_id';

/// Реализация [AuthRepository] поверх сгенерированного API-клиента (MADR-007),
/// [JwtAuthSession] (персист пары токенов) и [AuthStatusNotifier] (реактивный
/// флаг для router-guard, MADR-008).
///
/// Эндпоинты `/auth/email/*` и `/auth/logout` публичные — БЕЗ `authScopeExtra`
/// (scope `none` по умолчанию, `AuthInterceptor` не добавит bearer). Тело несёт
/// идентичность (email / opaque-токен / refresh-токен), идентичность здесь НЕ
/// хардкодится.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._api,
    this._session,
    this._status,
    this._social,
    this._secureStorage,
  );

  final PlantsCareApi _api;
  final JwtAuthSession _session;
  final AuthStatusNotifier _status;
  final SocialSignIn _social;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<Result<void>> requestMagicLink(String email) async {
    try {
      await _api.auth.requestMagicLink(body: EmailRequest(email: email));
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> verifyMagicLink(String token) async {
    try {
      final pair = await _api.auth.verifyMagicLink(
        body: MagicLinkVerifyRequest(token: token),
      );
      // Поднимаем сессию: персист пары + реактивный флаг для router-guard.
      await _raiseSession(pair);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<SocialAuthOutcome> signInWithGoogle() async {
    final String? idToken;
    try {
      idToken = await _social.googleIdToken();
    } catch (_) {
      // Не отмена (отмена → null): сбой SDK/конфигурации. Структурированной
      // ошибки провайдера у нас нет — дженерик unknown БЕЗ message, чтобы
      // messageForError дал общий текст и не утёк технический e.toString().
      return SocialAuthFailure(const ApiError.unknown());
    }
    if (idToken == null) return const SocialAuthOutcome.cancelled();

    try {
      final pair = await _api.auth.authGoogle(
        body: GoogleAuthRequest(idToken: idToken),
      );
      await _raiseSession(pair);
      return const SocialAuthOutcome.success();
    } on DioException catch (e) {
      return SocialAuthFailure(_toApiError(e));
    }
  }

  @override
  Future<SocialAuthOutcome> signInWithApple() async {
    final String? identityToken;
    try {
      identityToken = await _social.appleIdentityToken();
    } catch (_) {
      // Дженерик unknown БЕЗ message (см. signInWithGoogle): не утекаем
      // e.toString() в показываемое пользователю сообщение.
      return SocialAuthFailure(const ApiError.unknown());
    }
    if (identityToken == null) return const SocialAuthOutcome.cancelled();

    try {
      final pair = await _api.auth.authApple(
        body: AppleAuthRequest(identityToken: identityToken),
      );
      await _raiseSession(pair);
      return const SocialAuthOutcome.success();
    } on DioException catch (e) {
      return SocialAuthFailure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> signInAsGuest() async {
    try {
      final deviceId = await _getOrCreateDeviceId();
      final response = await _api.auth.guestLogin(
        body: GuestLoginRequest(deviceId: deviceId),
      );
      await _session.updateTokens(
        AuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
      _status.set(true);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<bool> tryRestoreGuestSession() async {
    // Если уже аутентифицированы — ничего делать не нужно.
    if (_session.isAuthenticated) return false;

    final deviceId = await _secureStorage.read(key: _guestDeviceIdKey);
    if (deviceId == null) return false;

    try {
      final response = await _api.auth.guestLogin(
        body: GuestLoginRequest(deviceId: deviceId),
      );
      await _session.updateTokens(
        AuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
      _status.set(true);
      return true;
    } on DioException catch (_) {
      // Восстановление best-effort: при ошибке просто не восстанавливаем.
      return false;
    }
  }

  @override
  Future<Result<void>> convertGuestWithEmail(String email) async {
    try {
      await _api.auth.guestConvert(
        body: GuestConvertRequest(
          provider: GuestConvertRequestProvider.email,
          email: email,
        ),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<SocialAuthOutcome> convertGuestWithGoogle() async {
    final String? idToken;
    try {
      idToken = await _social.googleIdToken();
    } catch (_) {
      return SocialAuthFailure(const ApiError.unknown());
    }
    if (idToken == null) return const SocialAuthOutcome.cancelled();

    try {
      final response = await _api.auth.guestConvert(
        body: GuestConvertRequest(
          provider: GuestConvertRequestProvider.google,
          idToken: idToken,
        ),
      );
      if (response.status == GuestConvertResponseStatus.converted &&
          response.accessToken != null &&
          response.refreshToken != null) {
        await _session.updateTokens(
          AuthTokens(
            accessToken: response.accessToken!,
            refreshToken: response.refreshToken!,
          ),
        );
        _status.set(true);
      }
      return const SocialAuthOutcome.success();
    } on DioException catch (e) {
      return SocialAuthFailure(_toApiError(e));
    }
  }

  @override
  Future<SocialAuthOutcome> convertGuestWithApple() async {
    final String? identityToken;
    try {
      identityToken = await _social.appleIdentityToken();
    } catch (_) {
      return SocialAuthFailure(const ApiError.unknown());
    }
    if (identityToken == null) return const SocialAuthOutcome.cancelled();

    try {
      final response = await _api.auth.guestConvert(
        body: GuestConvertRequest(
          provider: GuestConvertRequestProvider.apple,
          idToken: identityToken,
        ),
      );
      if (response.status == GuestConvertResponseStatus.converted &&
          response.accessToken != null &&
          response.refreshToken != null) {
        await _session.updateTokens(
          AuthTokens(
            accessToken: response.accessToken!,
            refreshToken: response.refreshToken!,
          ),
        );
        _status.set(true);
      }
      return const SocialAuthOutcome.success();
    } on DioException catch (e) {
      return SocialAuthFailure(_toApiError(e));
    }
  }

  /// Возвращает существующий `deviceId` из secure storage или генерирует новый
  /// UUID v4, сохраняет и возвращает его. Гарантирует идемпотентность.
  Future<String> _getOrCreateDeviceId() async {
    final existing = await _secureStorage.read(key: _guestDeviceIdKey);
    if (existing != null) return existing;
    final newId = const Uuid().v4();
    await _secureStorage.write(key: _guestDeviceIdKey, value: newId);
    return newId;
  }

  /// Поднимает сессию по полученной паре: персист токенов + реактивный auth-флаг
  /// для router-guard (как в [verifyMagicLink]).
  Future<void> _raiseSession(TokenPairResponse pair) async {
    await _session.updateTokens(
      AuthTokens(
        accessToken: pair.accessToken,
        refreshToken: pair.refreshToken,
      ),
    );
    _status.set(true);
  }

  @override
  Future<void> signOut() async {
    // Best-effort отзыв refresh: сетевая ошибка/чужой токен backend трактует
    // идемпотентно (204), нам она не важна — локальная сессия гасится в любом
    // случае.
    final refresh = _session.refreshToken;
    if (refresh != null) {
      try {
        await _api.auth.logout(body: LogoutRequest(refreshToken: refresh));
      } catch (_) {
        // Игнорируем: logout идемпотентен, локальный clear ниже обязателен.
      }
    }
    // Используем try/catch чтобы гарантировать сброс auth-флага даже при
    // ошибке хранилища (напр. FlutterSecureStorage на некоторых Android).
    // Без этого _status.set(false) не вызвался бы и router-guard не сработал —
    // logout «ничего не делал» в UI.
    try {
      await _session.clear();
    } catch (_) {
      // Игнорируем: токены уже инвалидны (сессия в памяти очищена в
      // JwtAuthSession.clear до броска), persist-сторадж best-effort.
    }
    _status.set(false);
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
