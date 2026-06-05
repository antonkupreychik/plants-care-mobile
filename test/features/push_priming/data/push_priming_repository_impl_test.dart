import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/features/push_priming/data/push_priming_repository_impl.dart';
import 'package:plantcare_mobile/features/push_priming/domain/push_priming_decision.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  const key = 'push_priming_decision';

  late MockFlutterSecureStorage storage;
  late PushPrimingRepositoryImpl repo;

  setUp(() {
    storage = MockFlutterSecureStorage();
    repo = PushPrimingRepositoryImpl(storage);
  });

  group('getDecision', () {
    test('should_return_allowed_when_stored_value_is_allowed', () async {
      when(() => storage.read(key: key)).thenAnswer((_) async => 'allowed');

      expect(await repo.getDecision(), PushPrimingDecision.allowed);
    });

    test('should_return_postponed_when_stored_value_is_postponed', () async {
      when(() => storage.read(key: key)).thenAnswer((_) async => 'postponed');

      expect(await repo.getDecision(), PushPrimingDecision.postponed);
    });

    test('should_return_notDecided_when_value_is_null', () async {
      // Первый запуск — ключа нет.
      when(() => storage.read(key: key)).thenAnswer((_) async => null);

      expect(await repo.getDecision(), PushPrimingDecision.notDecided);
    });

    test('should_return_notDecided_when_value_is_corrupt', () async {
      when(() => storage.read(key: key)).thenAnswer((_) async => 'xyz');

      expect(await repo.getDecision(), PushPrimingDecision.notDecided);
    });
  });

  group('saveDecision', () {
    test('should_write_decision_code_as_storage_value', () async {
      when(
        () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
      ).thenAnswer((_) async {});

      for (final decision in PushPrimingDecision.values) {
        await repo.saveDecision(decision);

        verify(() => storage.write(key: key, value: decision.code)).called(1);
      }
    });
  });
}
