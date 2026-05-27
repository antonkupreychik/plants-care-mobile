import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/env/app_config.dart';

/// Общий запуск приложения для обоих flavor (MADR-010). Точки входа
/// `main_dev.dart` / `main_prod.dart` вызывают это с нужным [Flavor].
void bootstrap(Flavor flavor) {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnv(flavor);

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
      ],
      child: const PlantCareApp(),
    ),
  );
}
