import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/observability/crash_reporter.dart';

/// Верифицирует, что [NoOpCrashReporter] не бросает и не зависает — все методы
/// — no-op. Тест важен как регрессия: в тестовой среде Sentry не инициализован,
/// prod-реализация недоступна, и тесты должны использовать no-op без сайд-эффектов.
void main() {
  group('NoOpCrashReporter', () {
    late NoOpCrashReporter reporter;

    setUp(() => reporter = const NoOpCrashReporter());

    test('reportError выполняется без исключений', () async {
      await expectLater(
        reporter.reportError(
          Exception('test'),
          StackTrace.current,
          hint: 'unit-test',
          extras: {'key': 'value'},
        ),
        completes,
      );
    });

    test('addBreadcrumb не бросает', () {
      expect(
        () => reporter.addBreadcrumb('nav', category: 'navigation'),
        returnsNormally,
      );
    });

    test('setTag не бросает', () {
      expect(
        () => reporter.setTag('env', 'dev'),
        returnsNormally,
      );
    });

    test('clearUser не бросает', () {
      expect(() => reporter.clearUser(), returnsNormally);
    });
  });
}
