import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Окружение сборки (MADR-010). Раздаётся в `--dart-define`, читается на старте.
enum Flavor { dev, prod }

/// Конфигурация приложения из `--dart-define` (MADR-010).
///
/// Dev-токен (MADR-008): [accessToken] / [refreshToken] задаются только в
/// dev-сборке как заранее выпущенная пара (`--dart-define=ACCESS_TOKEN=…`).
/// `bootstrap()` засевает ими [TokenStore], если хранилище пусто — так dev
/// поднимается без UI входа. В prod они null (вход — через экраны auth).
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiUrl,
    this.accessToken,
    this.refreshToken,
    this.googleServerClientId,
    this.googleIosClientId,
    this.sentryDsn,
  });

  final Flavor flavor;
  final String apiUrl;
  final String? accessToken;
  final String? refreshToken;

  /// Web (server) OAuth client ID Google'а (`GOOGLE_SERVER_CLIENT_ID`).
  /// Передаётся в `GoogleSignIn.initialize(serverClientId:)` — именно под него
  /// Google выпустит `id_token`, который понимает backend (audience = этот id).
  /// На Android (Credential Manager, google_sign_in 7.x) это единственный
  /// нужный client ID. Публичный (не секрет), но env-specific. `null` — если не
  /// задан в сборке.
  final String? googleServerClientId;

  /// iOS OAuth client ID Google'а (`GOOGLE_IOS_CLIENT_ID`). Передаётся в
  /// `GoogleSignIn.initialize(clientId:)` на iOS; должен совпадать с `GIDClientID`
  /// в `Info.plist`. Публичный, env-specific. `null` — если не задан.
  final String? googleIosClientId;

  /// Sentry DSN (`SENTRY_DSN`). Передаётся через `--dart-define=SENTRY_DSN=…`.
  /// В CI — из secrets. Не коммитится в репозиторий.
  /// `null` — Sentry не инициализируется (dev без DSN, unit-тесты).
  final String? sentryDsn;

  bool get isDev => flavor == Flavor.dev;

  /// Sentry включён: DSN задан.
  bool get isSentryEnabled => sentryDsn != null;

  static const String _apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://plants-care-development.up.railway.app',
  );
  static const String _accessToken = String.fromEnvironment('ACCESS_TOKEN');
  static const String _refreshToken = String.fromEnvironment('REFRESH_TOKEN');
  static const String _googleServerClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
  static const String _googleIosClientId =
      String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
  static const String _sentryDsn = String.fromEnvironment('SENTRY_DSN');

  factory AppConfig.fromEnv(Flavor flavor) {
    return AppConfig(
      flavor: flavor,
      apiUrl: _apiUrl,
      accessToken: _accessToken.isEmpty ? null : _accessToken,
      refreshToken: _refreshToken.isEmpty ? null : _refreshToken,
      googleServerClientId:
          _googleServerClientId.isEmpty ? null : _googleServerClientId,
      googleIosClientId:
          _googleIosClientId.isEmpty ? null : _googleIosClientId,
      sentryDsn: _sentryDsn.isEmpty ? null : _sentryDsn,
    );
  }
}

/// Глобальный конфиг. Реальное значение проставляется override'ом в `bootstrap`.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider overridden in bootstrap()'),
);
