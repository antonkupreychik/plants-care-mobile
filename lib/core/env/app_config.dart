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
  });

  final Flavor flavor;
  final String apiUrl;
  final String? accessToken;
  final String? refreshToken;

  bool get isDev => flavor == Flavor.dev;

  static const String _apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://plants-care-development.up.railway.app',
  );
  static const String _accessToken = String.fromEnvironment('ACCESS_TOKEN');
  static const String _refreshToken = String.fromEnvironment('REFRESH_TOKEN');

  factory AppConfig.fromEnv(Flavor flavor) {
    return AppConfig(
      flavor: flavor,
      apiUrl: _apiUrl,
      accessToken: _accessToken.isEmpty ? null : _accessToken,
      refreshToken: _refreshToken.isEmpty ? null : _refreshToken,
    );
  }
}

/// Глобальный конфиг. Реальное значение проставляется override'ом в `bootstrap`.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider overridden in bootstrap()'),
);
