import 'package:dio/dio.dart';

import '../../../core/api/generated/models/apple_auth_request.dart';
import '../../../core/api/generated/models/email_request.dart';
import '../../../core/api/generated/models/google_auth_request.dart';
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
  );

  final PlantsCareApi _api;
  final JwtAuthSession _session;
  final AuthStatusNotifier _status;
  final SocialSignIn _social;

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
    await _session.clear();
    _status.set(false);
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
