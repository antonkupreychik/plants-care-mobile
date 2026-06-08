import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/observability/analytics_event.dart';

void main() {
  group('AnalyticsEvent — name и params', () {
    test('AppStarted содержит flavor', () {
      const event = AppStarted(flavor: 'prod');
      expect(event.name, 'app_started');
      expect(event.params, {'flavor': 'prod'});
    });

    test('UserLoggedIn содержит method', () {
      const event = UserLoggedIn(method: 'google');
      expect(event.name, 'user_logged_in');
      expect(event.params, {'method': 'google'});
    });

    test('UserLoggedOut — пустые params', () {
      const event = UserLoggedOut();
      expect(event.name, 'user_logged_out');
      expect(event.params, isEmpty);
    });

    test('PlantAdded с speciesId', () {
      const event = PlantAdded(speciesId: '42');
      expect(event.name, 'plant_added');
      expect(event.params, {'species_id': '42'});
    });

    test('PlantAdded без speciesId (null) — params пустой', () {
      const event = PlantAdded(speciesId: null);
      expect(event.name, 'plant_added');
      expect(event.params, isEmpty);
    });

    test('CareEventRecorded содержит careType', () {
      const event = CareEventRecorded(careType: 'WATER');
      expect(event.name, 'care_event_recorded');
      expect(event.params, {'care_type': 'WATER'});
    });
  });

  group('AnalyticsEvent — PII отсутствие', () {
    test('UserLoggedIn не содержит email или userId', () {
      const event = UserLoggedIn(method: 'magic_link');
      final allValues = event.params.values.toList().toString();
      // Проверяем: в params нет полей похожих на PII (email, @, phone).
      expect(allValues, isNot(contains('@')));
    });

    test('PlantAdded не содержит имя растения', () {
      // PlantAdded несёт только speciesId (числовой ID вида), не имя.
      const event = PlantAdded(speciesId: '7');
      expect(event.params.keys, equals(['species_id']));
    });
  });
}
