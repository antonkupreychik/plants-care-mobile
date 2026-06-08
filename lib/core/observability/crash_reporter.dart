import 'package:sentry_flutter/sentry_flutter.dart';

/// Абстракция для crash-репортинга (issue #126).
///
/// В продакшне за ней стоит Sentry; в тестах — [NoOpCrashReporter].
/// Код domain/data не зависит от Sentry напрямую — зависит от этого интерфейса.
abstract class CrashReporter {
  /// Репортит пойманное исключение [exception] со стектрейсом [stackTrace].
  ///
  /// [hint] — произвольный контекст (откуда поймано, какой контекст был).
  Future<void> reportError(
    Object exception,
    StackTrace stackTrace, {
    String? hint,
    Map<String, dynamic>? extras,
  });

  /// Добавляет breadcrumb для трассировки (навигация, действия юзера).
  void addBreadcrumb(String message, {String? category});

  /// Устанавливает тег для всех последующих событий (например, userId: анонимный хэш).
  void setTag(String key, String value);

  /// Сбрасывает identity (при логауте).
  void clearUser();
}

/// Prod-реализация поверх Sentry (issue #126).
///
/// PII: userId передаётся только как хэш — Sentry не получает email / имя /
/// deviceId в чистом виде. IP capture отключён через `sendDefaultPii: false`
/// в [SentryFlutterOptions].
class SentryCrashReporter implements CrashReporter {
  const SentryCrashReporter();

  @override
  Future<void> reportError(
    Object exception,
    StackTrace stackTrace, {
    String? hint,
    Map<String, dynamic>? extras,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint != null ? Hint.withMap({'message': hint}) : null,
      withScope: extras != null
          ? (scope) {
              for (final entry in extras.entries) {
                // setContexts — рекомендованная замена устаревшего setExtra
                // (Sentry SDK 9.x). Принимает строку и любое значение.
                scope.setContexts(entry.key, entry.value);
              }
            }
          : null,
    );
  }

  @override
  void addBreadcrumb(String message, {String? category}) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        type: 'default',
      ),
    );
  }

  @override
  void setTag(String key, String value) {
    Sentry.configureScope((scope) => scope.setTag(key, value));
  }

  @override
  void clearUser() {
    Sentry.configureScope((scope) => scope.setUser(null));
  }
}

/// No-op реализация для dev-сборки и тестов (не отправляет ничего в сеть).
class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  Future<void> reportError(
    Object exception,
    StackTrace stackTrace, {
    String? hint,
    Map<String, dynamic>? extras,
  }) async {}

  @override
  void addBreadcrumb(String message, {String? category}) {}

  @override
  void setTag(String key, String value) {}

  @override
  void clearUser() {}
}
