import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/auth/auth_providers.dart';
import 'core/auth/jwt_auth_session.dart';
import 'core/auth/token_store.dart';
import 'core/env/app_config.dart';
import 'core/observability/analytics_event.dart';
import 'core/observability/analytics_service.dart';
import 'core/observability/crash_reporter.dart';
import 'core/observability/observability_providers.dart';

/// Ключ гостевого deviceId в [FlutterSecureStorage].
/// Должен совпадать с `_guestDeviceIdKey` в `AuthRepositoryImpl`.
const _guestDeviceIdKey = 'guest_device_id';

/// Общий запуск приложения для обоих flavor (MADR-010). Точки входа
/// `main_dev.dart` / `main_prod.dart` вызывают это с нужным [Flavor].
///
/// Async: до `runApp` читаем пару токенов из защищённого хранилища (MADR-008),
/// чтобы [JwtAuthSession] стартовал уже аутентифицированным. В dev, если
/// хранилище пусто, засеваем его токеном из `--dart-define` (ACCESS_TOKEN/
/// REFRESH_TOKEN) — приложение поднимается без UI входа.
///
/// Гостевая сессия: если токенов нет, но в хранилище есть `guest_device_id` —
/// попытка восстановить гостевую сессию через `POST /auth/guest` ещё до
/// `runApp`. Это позволяет гостю не видеть экран входа при повторном запуске.
///
/// Crash-репортинг (issue #126): если `SENTRY_DSN` задан через `--dart-define`,
/// приложение запускается внутри [SentryFlutter.init] — это обеспечивает:
/// - перехват необработанных Flutter-исключений (FlutterError.onError);
/// - перехват Dart-изолятов (PlatformDispatcher.onError);
/// - нативные крэши Android (NDK) / iOS;
/// - привязку release/dist для символизации dSYM/ProGuard.
/// Без DSN (dev без CI-секрета, тесты) — no-op реализации, ноль сетевых вызовов.
Future<void> bootstrap(Flavor flavor) async {
  final config = AppConfig.fromEnv(flavor);

  if (config.isSentryEnabled) {
    await SentryFlutter.init(
      (options) => _configureSentry(options, config),
      appRunner: () => _runApp(config),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await _runApp(config);
  }
}

/// Конфигурирует [SentryFlutterOptions] (issue #126).
void _configureSentry(SentryFlutterOptions options, AppConfig config) {
  options
    // DSN из --dart-define (не коммитится в репо).
    ..dsn = config.sentryDsn!
    // release = <appVersion>+<buildNumber>, dist = buildNumber.
    // Sentry сопоставляет эти поля с загруженными dSYM/mapping файлами.
    ..release = '1.0.0+1'
    ..dist = '1'
    // Окружение: 'dev' или 'prod'.
    ..environment = config.isDev ? 'dev' : 'prod'
    // PII: не отправляем IP-адрес, не собираем email/phone.
    ..sendDefaultPii = false
    // Breadcrumbs HTTP-запросов для трассировки (без тел запросов — только URL+status).
    ..maxBreadcrumbs = 100
    // Трассировка производительности (sampling — 10% в проде, 100% в dev).
    ..tracesSampleRate = config.isDev ? 1.0 : 0.1;
}

/// Основная логика инициализации и запуска [PlantCareApp].
///
/// Вызывается как callback из [SentryFlutter.init] (если DSN есть)
/// или напрямую (если DSN не задан).
Future<void> _runApp(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();
  final store = TokenStore(secureStorage);

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

  // Восстановление гостевой сессии: если нет токенов, но есть сохранённый
  // deviceId — гость не должен попасть на экран входа при перезапуске.
  // Попытка best-effort: при ошибке сети — молча пропускаем, пользователь
  // увидит экран входа и сможет войти снова.
  tokens ??= await _tryRestoreGuestTokens(secureStorage, store, config.apiUrl);

  final session = JwtAuthSession(store, initial: tokens);

  // Выбираем реализации observability по наличию DSN (issue #126).
  final CrashReporter crashReporter;
  final AnalyticsService analyticsService;
  if (config.isSentryEnabled) {
    crashReporter = const SentryCrashReporter();
    analyticsService = const SentryAnalyticsService();
  } else {
    crashReporter = const NoOpCrashReporter();
    analyticsService = const NoOpAnalyticsService();
  }

  // Трекаем старт приложения.
  analyticsService.track(AppStarted(flavor: config.isDev ? 'dev' : 'prod'));

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        tokenStoreProvider.overrideWithValue(store),
        jwtAuthSessionProvider.overrideWithValue(session),
        crashReporterProvider.overrideWithValue(crashReporter),
        analyticsServiceProvider.overrideWithValue(analyticsService),
      ],
      child: const PlantCareApp(),
    ),
  );
}

/// Пытается восстановить гостевую сессию по сохранённому `guest_device_id`.
///
/// Если есть `guest_device_id` в secure storage — делает HTTP-запрос
/// `POST /auth/guest`. При успехе персистит новую пару токенов и возвращает её.
/// При любой ошибке возвращает `null` (best-effort).
Future<AuthTokens?> _tryRestoreGuestTokens(
  FlutterSecureStorage secureStorage,
  TokenStore store,
  String apiUrl,
) async {
  final deviceId = await secureStorage.read(key: _guestDeviceIdKey);
  if (deviceId == null) return null;

  try {
    final dio = Dio(BaseOptions(baseUrl: apiUrl));
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/auth/guest',
      data: {'deviceId': deviceId},
    );
    final data = response.data;
    if (data == null) return null;
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    if (accessToken == null || refreshToken == null) return null;
    final tokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await store.write(tokens);
    return tokens;
  } catch (_) {
    // Best-effort: сеть недоступна или backend вернул ошибку — гость увидит
    // экран входа, где снова нажмёт «Продолжить без аккаунта».
    return null;
  }
}
