import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';
import 'core/auth/auth_providers.dart';
import 'core/auth/jwt_auth_session.dart';
import 'core/auth/token_store.dart';
import 'core/env/app_config.dart';

/// Общий запуск приложения для обоих flavor (MADR-010). Точки входа
/// `main_dev.dart` / `main_prod.dart` вызывают это с нужным [Flavor].
///
/// Async: до `runApp` читаем пару токенов из защищённого хранилища (MADR-008),
/// чтобы [JwtAuthSession] стартовал уже аутентифицированным. В dev, если
/// хранилище пусто, засеваем его токеном из `--dart-define` (ACCESS_TOKEN/
/// REFRESH_TOKEN) — приложение поднимается без UI входа.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnv(flavor);
  final store = TokenStore(const FlutterSecureStorage());

  var tokens = await store.read();
  if (tokens == null &&
      config.isDev &&
      config.accessToken != null &&
      config.refreshToken != null) {
    tokens = AuthTokens(
      accessToken: config.accessToken!,
      refreshToken: config.refreshToken!,
    );
    await store.write(tokens);
  }

  final session = JwtAuthSession(store, initial: tokens);

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        tokenStoreProvider.overrideWithValue(store),
        jwtAuthSessionProvider.overrideWithValue(session),
      ],
      child: const PlantCareApp(),
    ),
  );
}
