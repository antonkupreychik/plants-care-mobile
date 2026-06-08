import 'package:sentry_flutter/sentry_flutter.dart';

import 'analytics_event.dart';

/// Сервис продуктовой аналитики (issue #126).
///
/// Реализует трекинг ключевых событий через Sentry breadcrumbs + structured
/// data. В будущем можно добавить второй транспорт (Amplitude, PostHog) без
/// изменения call-sites.
///
/// PII-политика:
/// - Не логируем: email, имена юзеров, названия растений, геолокацию.
/// - Логируем: анонимные ID видов, тип операции, flavor сборки.
abstract class AnalyticsService {
  /// Отправляет событие аналитики.
  void track(AnalyticsEvent event);
}

/// Sentry-реализация: пишет события как breadcrumbs с category = event.name.
///
/// Breadcrumbs видны в Sentry рядом с крэшем → понятно что делал юзер перед
/// падением. Для событий без крэша — [Sentry.captureMessage] с level info.
class SentryAnalyticsService implements AnalyticsService {
  const SentryAnalyticsService();

  @override
  void track(AnalyticsEvent event) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: event.name,
        category: 'analytics',
        data: event.params.isNotEmpty ? event.params : null,
        type: 'user',
      ),
    );
  }
}

/// No-op реализация для dev-сборки без DSN и тестов.
class NoOpAnalyticsService implements AnalyticsService {
  const NoOpAnalyticsService();

  @override
  void track(AnalyticsEvent event) {}
}
