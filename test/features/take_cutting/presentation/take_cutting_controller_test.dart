import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/take_cutting/data/take_cutting_repository_provider.dart';
import 'package:plantcare_mobile/features/take_cutting/domain/propagation_method.dart';
import 'package:plantcare_mobile/features/take_cutting/domain/take_cutting_repository.dart';
import 'package:plantcare_mobile/features/take_cutting/presentation/take_cutting_controller.dart';
import 'package:plantcare_mobile/features/take_cutting/presentation/take_cutting_state.dart';

class _MockRepo extends Mock implements TakeCuttingRepository {}

/// Часы, замороженные на не-UTC времени, чтобы проверить, что дата среза по
/// умолчанию = «сегодня» в локальной зоне, а не UTC-день.
class _FixedClock implements Clock {
  _FixedClock(this._utc);
  final DateTime _utc;
  @override
  DateTime nowUtc() => _utc;
}

const _parentId = 42;

ProviderContainer _makeContainer({
  required _MockRepo repo,
  required DateTime utcNow,
}) {
  final container = ProviderContainer(
    overrides: [
      takeCuttingRepositoryProvider.overrideWithValue(repo),
      clockProvider.overrideWithValue(_FixedClock(utcNow)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() {
    registerFallbackValue(const ApiError.unknown());
  });

  group('build', () {
    test('defaults cutAt to local today and method to water', () {
      // 2026-05-13T23:30Z → в зонах восточнее UTC это уже 14-е, но мы проверяем
      // только что дата = локальный сегодняшний день из часов (без времени).
      final utcNow = DateTime.utc(2026, 5, 13, 12);
      final container = _makeContainer(repo: _MockRepo(), utcNow: utcNow);

      final state = container.read(
        takeCuttingControllerProvider(_parentId),
      );

      final localToday = utcNow.toLocal();
      expect(state.method, PropagationMethod.water);
      expect(state.cutAt, isNotNull);
      expect(state.cutAt!.year, localToday.year);
      expect(state.cutAt!.month, localToday.month);
      expect(state.cutAt!.day, localToday.day);
      // Дата без времени.
      expect(state.cutAt!.hour, 0);
      expect(state.cutAt!.minute, 0);
    });
  });

  group('canSubmit', () {
    test('is false on empty name and true on valid trimmed name', () {
      final container = _makeContainer(
        repo: _MockRepo(),
        utcNow: DateTime.utc(2026, 5, 13),
      );
      final notifier = container.read(
        takeCuttingControllerProvider(_parentId).notifier,
      );

      expect(
        container.read(takeCuttingControllerProvider(_parentId)).canSubmit,
        isFalse,
      );

      notifier.setName('  Моник  ');
      expect(
        container.read(takeCuttingControllerProvider(_parentId)).canSubmit,
        isTrue,
      );

      notifier.setName('   ');
      expect(
        container.read(takeCuttingControllerProvider(_parentId)).canSubmit,
        isFalse,
      );
    });
  });

  group('selectMethod', () {
    test('toggles active method', () {
      final container = _makeContainer(
        repo: _MockRepo(),
        utcNow: DateTime.utc(2026, 5, 13),
      );
      final notifier = container.read(
        takeCuttingControllerProvider(_parentId).notifier,
      );

      notifier.selectMethod(PropagationMethod.soil);
      expect(
        container.read(takeCuttingControllerProvider(_parentId)).method,
        PropagationMethod.soil,
      );
    });
  });

  group('submit', () {
    test('sends trimmed name and parentPlantId, returns id on success',
        () async {
      final repo = _MockRepo();
      when(() => repo.createCutting(
            name: any(named: 'name'),
            parentPlantId: any(named: 'parentPlantId'),
          )).thenAnswer((_) async => const Result.success(99));

      final container = _makeContainer(
        repo: repo,
        utcNow: DateTime.utc(2026, 5, 13),
      );
      final notifier = container.read(
        takeCuttingControllerProvider(_parentId).notifier,
      );
      notifier.setName('  Моник  ');

      final id = await notifier.submit();

      expect(id, 99);
      verify(() => repo.createCutting(name: 'Моник', parentPlantId: _parentId))
          .called(1);
      expect(
        container.read(takeCuttingControllerProvider(_parentId)).status,
        const TakeCuttingSubmitStatus.success(99),
      );
    });

    test('does not call repo when name invalid', () async {
      final repo = _MockRepo();
      final container = _makeContainer(
        repo: repo,
        utcNow: DateTime.utc(2026, 5, 13),
      );
      final notifier = container.read(
        takeCuttingControllerProvider(_parentId).notifier,
      );

      final id = await notifier.submit();

      expect(id, isNull);
      verifyNever(() => repo.createCutting(
            name: any(named: 'name'),
            parentPlantId: any(named: 'parentPlantId'),
          ));
    });

    test('puts failure status and returns null on repo failure', () async {
      final repo = _MockRepo();
      when(() => repo.createCutting(
            name: any(named: 'name'),
            parentPlantId: any(named: 'parentPlantId'),
          )).thenAnswer((_) async => const Result.failure(ApiError.notFound()));

      final container = _makeContainer(
        repo: repo,
        utcNow: DateTime.utc(2026, 5, 13),
      );
      final notifier = container.read(
        takeCuttingControllerProvider(_parentId).notifier,
      );
      notifier.setName('Моник');

      final id = await notifier.submit();

      expect(id, isNull);
      expect(
        container.read(takeCuttingControllerProvider(_parentId)).status,
        const TakeCuttingSubmitStatus.failure(ApiError.notFound()),
      );
    });
  });
}
