import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/observability/analytics_event.dart';
import 'package:plantcare_mobile/core/observability/analytics_service.dart';

void main() {
  group('NoOpAnalyticsService', () {
    late NoOpAnalyticsService service;

    setUp(() => service = const NoOpAnalyticsService());

    test('track не бросает для AppStarted', () {
      expect(
        () => service.track(const AppStarted(flavor: 'dev')),
        returnsNormally,
      );
    });

    test('track не бросает для UserLoggedIn', () {
      expect(
        () => service.track(const UserLoggedIn(method: 'google')),
        returnsNormally,
      );
    });

    test('track не бросает для PlantAdded', () {
      expect(
        () => service.track(const PlantAdded(speciesId: '1')),
        returnsNormally,
      );
    });

    test('track не бросает для CareEventRecorded', () {
      expect(
        () => service.track(const CareEventRecorded(careType: 'WATER')),
        returnsNormally,
      );
    });
  });
}
