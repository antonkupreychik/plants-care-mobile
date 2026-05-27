import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/add_plant/domain/care_difficulty.dart';

void main() {
  group('CareDifficulty.fromApi', () {
    test('should_map_EASY', () {
      expect(CareDifficulty.fromApi('EASY'), CareDifficulty.easy);
    });

    test('should_map_MEDIUM', () {
      expect(CareDifficulty.fromApi('MEDIUM'), CareDifficulty.medium);
    });

    test('should_map_HARD', () {
      expect(CareDifficulty.fromApi('HARD'), CareDifficulty.hard);
    });

    test('should_be_case_insensitive', () {
      expect(CareDifficulty.fromApi('easy'), CareDifficulty.easy);
    });

    test('should_map_unrecognized_to_unknown', () {
      expect(CareDifficulty.fromApi('EXTREME'), CareDifficulty.unknown);
    });

    test('should_map_null_to_unknown', () {
      expect(CareDifficulty.fromApi(null), CareDifficulty.unknown);
    });
  });
}
