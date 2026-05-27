import 'dart:io';

import 'package:dio/dio.dart';

import '../error/api_error.dart';

/// Нормализует `DioException` (+ тело `{error:{code,message,details}}`) в
/// [ApiError] и кладёт его в `DioException.error` (MADR-006/011). Тонкий слой
/// data ловит `on DioException` и заворачивает в `Result.failure`.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(err.copyWith(error: _map(err)));
  }

  ApiError _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ApiError.network();
      case DioExceptionType.unknown:
        if (err.error is SocketException) return const ApiError.network();
      default:
        break;
    }

    final response = err.response;
    final data = response?.data;
    if (data is Map && data['error'] is Map) {
      final error = data['error'] as Map;
      final code = error['code'] as String?;
      final message = error['message'] as String?;
      switch (code) {
        case 'VALIDATION_ERROR':
          final details = (error['details'] as List?)
                  ?.whereType<Map>()
                  .map(
                    (e) => FieldError(
                      field: e['field'] as String? ?? '',
                      message: e['message'] as String? ?? '',
                    ),
                  )
                  .toList() ??
              const [];
          return ApiError.validation(details: details);
        case 'BAD_REQUEST':
          return ApiError.badRequest(message: message);
        case 'LOCATION_NOT_EMPTY':
          return const ApiError.locationNotEmpty();
        case 'ACCESS_DENIED':
          return const ApiError.accessDenied();
        case 'NOT_FOUND':
          return const ApiError.notFound();
        case 'CONFLICT':
          return const ApiError.conflict();
        case 'INTERNAL_ERROR':
          return ApiError.unknown(message: message);
        default:
          break;
      }
    }

    // Fallback по HTTP-статусу, если тело не распознано.
    return switch (response?.statusCode) {
      403 => const ApiError.accessDenied(),
      404 => const ApiError.notFound(),
      409 => const ApiError.conflict(),
      _ => const ApiError.unknown(),
    };
  }
}
