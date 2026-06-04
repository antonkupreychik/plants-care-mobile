import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/env/app_config.dart';
import '../domain/social_sign_in.dart';

part 'social_sign_in_impl.g.dart';

/// Реализация [SocialSignIn] на пакетах google_sign_in 7.x и
/// sign_in_with_apple 8.x.
///
/// google_sign_in 7.x — instance-based API: единственный синглтон
/// `GoogleSignIn.instance`, который нужно один раз проинициализировать
/// (`initialize`) перед первым `authenticate()`. `initialize` нельзя звать
/// повторно за процесс, а `socialSignInProvider` autoDispose — между
/// пересозданиями инстансы меняются. Поэтому гард на init — **статический**
/// (per-process), а не per-instance (см. [_ensureGoogleInitialized]).
///
/// client ID берутся из [AppConfig] (передаются через `--dart-define`):
/// - [AppConfig.googleServerClientId] (web client) → `serverClientId`; под него
///   Google выпустит `id_token` с нужным backend'у audience. На Android это
///   единственный требуемый id.
/// - [AppConfig.googleIosClientId] → `clientId`; нужен на iOS.
class SocialSignInImpl implements SocialSignIn {
  SocialSignInImpl({
    required this.googleServerClientId,
    required this.googleIosClientId,
  });

  /// Web (server) OAuth client ID — `GoogleSignIn.initialize(serverClientId:)`.
  final String? googleServerClientId;

  /// iOS OAuth client ID — `GoogleSignIn.initialize(clientId:)`.
  final String? googleIosClientId;

  /// Статический (per-process) гард на инициализацию глобального синглтона
  /// `GoogleSignIn.instance`. Кешируем сам `Future`: `initialize` стартует
  /// ровно один раз за процесс, независимо от lifecycle провайдера (autoDispose
  /// пересоздаёт инстансы — флаг на инстансе был бы неверен). Конкурентные
  /// вызовы дожидаются того же Future.
  ///
  /// Сбрасываем (`= null`) при провале, чтобы следующий вход мог переинициировать
  /// (напр. временная ошибка платформенного канала на холодном старте).
  static Future<void>? _googleInit;

  Future<void> _ensureGoogleInitialized() {
    return _googleInit ??= () async {
      try {
        await GoogleSignIn.instance.initialize(
          clientId: googleIosClientId,
          serverClientId: googleServerClientId,
        );
      } catch (_) {
        _googleInit = null;
        rethrow;
      }
    }();
  }

  @override
  Future<String?> googleIdToken() async {
    // На неподдерживаемых платформах authenticate() бросает UnsupportedError —
    // отсекаем заранее дженерик-failure'ом (репозиторий завернёт без тех-текста).
    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      throw const SocialSignInUnsupported();
    }
    await _ensureGoogleInitialized();
    try {
      // authenticate() кидает GoogleSignInException на любой неуспех, включая
      // отмену пользователем (code == canceled) — её гасим в null.
      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();
      final String? idToken = account.authentication.idToken;
      if (idToken == null) {
        // SDK вошёл, но не отдал id_token — обычно мисконфигурация
        // serverClientId. Это реальная ошибка, а не отмена.
        throw StateError(
          'Google sign-in succeeded but returned no idToken '
          '(check GOOGLE_SERVER_CLIENT_ID)',
        );
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<String?> appleIdentityToken() async {
    // Платформенный guard на data-слое (в UI кнопка скрыта на Android, но это
    // не защита data): на не-iOS возвращаем null — трактуется как «недоступно/
    // отмена», без ошибки и без показа сообщения пользователю.
    if (!Platform.isIOS) return null;
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        // Запрашиваем минимум для обмена на JWT: identityToken приходит всегда,
        // email/fullName — только при первой авторизации; backend идентифицирует
        // по identityToken, эти поля ему сейчас не нужны.
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String? identityToken = credential.identityToken;
      if (identityToken == null) {
        throw StateError(
          'Apple sign-in succeeded but returned no identityToken',
        );
      }
      return identityToken;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }
}

/// Платформа/окружение не поддерживает интерактивный вход. Бросается до вызова
/// SDK; репозиторий заворачивает в `SocialAuthFailure(ApiError.unknown())` БЕЗ
/// технического текста (UI покажет общий `errorGeneric`).
class SocialSignInUnsupported implements Exception {
  const SocialSignInUnsupported();

  @override
  String toString() => 'SocialSignInUnsupported';
}

/// DI-точка для [SocialSignIn] (MADR-004). client ID резолвятся из
/// [appConfigProvider]; в тестах подменяется через
/// `socialSignInProvider.overrideWith(...)`.
@riverpod
SocialSignIn socialSignIn(Ref ref) {
  final config = ref.watch(appConfigProvider);
  return SocialSignInImpl(
    googleServerClientId: config.googleServerClientId,
    googleIosClientId: config.googleIosClientId,
  );
}
