// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/apple_auth_request.dart';
import '../models/email_request.dart';
import '../models/google_auth_request.dart';
import '../models/logout_request.dart';
import '../models/magic_link_verify_request.dart';
import '../models/refresh_request.dart';
import '../models/token_pair_response.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// Вход через Sign in with Apple.
  ///
  /// Принимает `identityToken` (JWT, выданный Apple). Сервер верифицирует.
  /// его подпись по Apple JWKS, проверяет `iss`/`aud`/`exp`, извлекает.
  /// стабильный `sub` (apple_subject) и email. Линковка с существующим.
  /// пользователем — по email; если пользователя нет — создаётся новый.
  @POST('/api/v1/auth/apple')
  Future<TokenPairResponse> authApple({
    @Body() required AppleAuthRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Вход через Google.
  ///
  /// Принимает Google `idToken`. Сервер верифицирует подпись по Google JWKS,.
  /// проверяет `iss`/`aud`/`exp` и требует `email_verified = true`. Линковка.
  /// по email.
  @POST('/api/v1/auth/google')
  Future<TokenPairResponse> authGoogle({
    @Body() required GoogleAuthRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Запросить magic link на email.
  ///
  /// Отправляет на указанный email одноразовую ссылку для входа. Ради защиты.
  /// от перебора (enumeration) эндпоинт **всегда** отвечает `202`, независимо.
  /// от того, существует ли пользователь. Ограничен rate-limit'ом по IP и по.
  /// email.
  @POST('/api/v1/auth/email/request')
  Future<void> requestMagicLink({
    @Body() required EmailRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Обменять magic-link токен на пару токенов.
  ///
  /// Принимает opaque-токен из письма. Токен одноразовый: после успешного.
  /// обмена помечается использованным и повторно не принимается. Линковка по.
  /// email, при необходимости создаётся новый пользователь.
  @POST('/api/v1/auth/email/verify')
  Future<TokenPairResponse> verifyMagicLink({
    @Body() required MagicLinkVerifyRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Ротация пары токенов по refresh-токену.
  ///
  /// Принимает refresh-токен, проверяет подпись/срок/тип и что его `jti` не.
  /// отозван. Старый refresh атомарно отзывается (защита от повторного.
  /// использования), выдаётся новая пара. Если токен уже отозван — `401`.
  /// с кодом `TOKEN_REVOKED`.
  @POST('/api/v1/auth/refresh')
  Future<TokenPairResponse> refreshTokens({
    @Body() required RefreshRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Выйти из текущей сессии (отозвать refresh-токен).
  ///
  /// Отзывает предъявленный refresh-токен текущего пользователя. Толерантен.
  /// и идемпотентен: повторный logout того же токена, а также невалидный/.
  /// просроченный/чужой токен возвращают `204` без ошибки.
  @POST('/api/v1/auth/logout')
  Future<void> logout({
    @Body() required LogoutRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Выйти со всех устройств (инвалидировать все refresh-токены).
  ///
  /// Выставляет эпоху валидности токенов пользователя в текущий момент,.
  /// одномоментно инвалидируя все ранее выданные refresh-токены. На следующей.
  /// ротации старый refresh получит `401 TOKEN_REVOKED`.
  @POST('/api/v1/auth/logout-all')
  Future<void> logoutAll({
    @Extras() Map<String, dynamic>? extras,
  });
}
