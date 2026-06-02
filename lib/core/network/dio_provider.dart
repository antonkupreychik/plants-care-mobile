import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/generated/clients/auth_client.dart';
import '../auth/auth_providers.dart';
import '../env/app_config.dart';
import 'auth_interceptor.dart';
import 'date_query_interceptor.dart';
import 'error_interceptor.dart';
import 'refresh_interceptor.dart';

part 'dio_provider.g.dart';

/// Сконфигурированный [Dio] (MADR-006/008). baseUrl = `{apiUrl}` (пути
/// сгенерированного клиента уже включают `/api/v1`).
///
/// Порядок интерсепторов: Auth (подставляет bearer) → DateQuery (фикс date-only
/// до ухода в сеть) → Refresh (ротация на 401) → Retry (сеть/5xx) → Error
/// (последним — маппинг в [ApiError] уже после исчерпания ретраев и refresh).
@riverpod
Dio dio(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final session = ref.watch(authSessionProvider);
  final jwtSession = ref.watch(jwtAuthSessionProvider);

  final dio = Dio(_baseOptions(config));

  // Отдельный «голый» Dio для `/auth/refresh`: без Auth/Refresh-интерсепторов,
  // чтобы ротация не слала протухший bearer и не уходила в рекурсию.
  final refreshDio = Dio(_baseOptions(config));
  final refreshClient = AuthClient(refreshDio);

  dio.interceptors.addAll([
    AuthInterceptor(session),
    DateQueryInterceptor(),
    RefreshInterceptor(
      session: jwtSession,
      refreshClient: refreshClient,
      retryDio: dio,
      // Невозвратный отказ refresh: RefreshInterceptor уже почистил сессию —
      // здесь только флипаем реактивный флаг, чтобы router-guard (MADR-008)
      // увёл на `/auth/welcome`.
      onSessionExpired: () => ref.read(authStatusProvider).set(false),
    ),
    RetryInterceptor(dio: dio, retries: 3),
    ErrorInterceptor(),
  ]);

  return dio;
}

BaseOptions _baseOptions(AppConfig config) => BaseOptions(
      baseUrl: config.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Content-Type': 'application/json'},
    );
