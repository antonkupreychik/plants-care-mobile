import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_providers.dart';
import '../env/app_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

part 'dio_provider.g.dart';

/// Сконфигурированный [Dio] (MADR-006). baseUrl = `{apiUrl}/api/v1`.
/// Порядок интерсепторов: Auth → Retry (сеть/5xx) → Error (последним, чтобы
/// маппить в [ApiError] уже после исчерпания ретраев).
@riverpod
Dio dio(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final session = ref.watch(authSessionProvider);

  final dio = Dio(
    BaseOptions(
      // Пути в сгенерированном клиенте уже включают префикс /api/v1,
      // поэтому baseUrl — только хост.
      baseUrl: config.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(session),
    RetryInterceptor(dio: dio, retries: 3),
    ErrorInterceptor(),
  ]);

  return dio;
}
