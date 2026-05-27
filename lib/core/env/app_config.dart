import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Окружение сборки (MADR-010). Раздаётся в `--dart-define`, читается на старте.
enum Flavor { dev, prod }

/// Конфигурация приложения из `--dart-define` (MADR-010).
///
/// Dev-слот auth (MADR-008): [chatId] / [userId] существуют только в dev-сборке;
/// в prod они null и сетевой слой пойдёт без PoC-заголовков (до появления JWT).
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiUrl,
    this.chatId,
    this.userId,
  });

  final Flavor flavor;
  final String apiUrl;
  final String? chatId;
  final String? userId;

  bool get isDev => flavor == Flavor.dev;

  static const String _apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://plants-care-development.up.railway.app',
  );
  static const String _chatId = String.fromEnvironment('CHAT_ID');
  static const String _userId = String.fromEnvironment('USER_ID');

  factory AppConfig.fromEnv(Flavor flavor) {
    return AppConfig(
      flavor: flavor,
      apiUrl: _apiUrl,
      chatId: _chatId.isEmpty ? null : _chatId,
      userId: _userId.isEmpty ? null : _userId,
    );
  }
}

/// Глобальный конфиг. Реальное значение проставляется override'ом в `bootstrap`.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider overridden in bootstrap()'),
);
