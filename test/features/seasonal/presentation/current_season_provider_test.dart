import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/features/seasonal/domain/season.dart';
import 'package:plantcare_mobile/features/seasonal/presentation/current_season_provider.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

Season _seasonAt(DateTime utc) {
  final container = ProviderContainer(
    overrides: [clockProvider.overrideWithValue(_FixedClock(utc))],
  );
  addTearDown(container.dispose);
  return container.read(currentSeasonProvider);
}

void main() {
  group('currentSeasonProvider', () {
    test('should_be_winter_in_january', () {
      expect(_seasonAt(DateTime.utc(2026, 1, 15)), Season.winter);
    });

    test('should_be_spring_in_april', () {
      expect(_seasonAt(DateTime.utc(2026, 4, 10)), Season.spring);
    });

    test('should_be_summer_in_july', () {
      expect(_seasonAt(DateTime.utc(2026, 7, 1)), Season.summer);
    });

    test('should_be_autumn_in_october', () {
      expect(_seasonAt(DateTime.utc(2026, 10, 20)), Season.autumn);
    });

    test('should_be_winter_in_december', () {
      expect(_seasonAt(DateTime.utc(2026, 12, 31)), Season.winter);
    });
  });

  group('Season.ofMonth', () {
    test('should_map_warm_half_correctly', () {
      expect(Season.spring.isWarmHalf, isTrue);
      expect(Season.summer.isWarmHalf, isTrue);
      expect(Season.autumn.isWarmHalf, isFalse);
      expect(Season.winter.isWarmHalf, isFalse);
    });
  });
}
