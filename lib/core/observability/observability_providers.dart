import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_service.dart';
import 'crash_reporter.dart';

/// Провайдер crash-репортера (issue #126).
///
/// Дефолтное значение — [NoOpCrashReporter]; продакшн-реализация
/// [SentryCrashReporter] переопределяется в bootstrap() через
/// `ProviderScope(overrides: [...])` — только если SENTRY_DSN не пустой.
final crashReporterProvider = Provider<CrashReporter>(
  (_) => const NoOpCrashReporter(),
  name: 'crashReporterProvider',
);

/// Провайдер сервиса аналитики (issue #126).
///
/// Аналогично [crashReporterProvider]: дефолт — no-op, продакшн —
/// [SentryAnalyticsService], проставляется override'ом в bootstrap().
final analyticsServiceProvider = Provider<AnalyticsService>(
  (_) => const NoOpAnalyticsService(),
  name: 'analyticsServiceProvider',
);
