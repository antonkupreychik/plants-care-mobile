import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/push_priming/domain/push_priming_decision.dart';

void main() {
  group('PushPrimingDecision.fromCode', () {
    test('should_return_allowed_when_code_is_allowed', () {
      expect(
        PushPrimingDecision.fromCode('allowed'),
        PushPrimingDecision.allowed,
      );
    });

    test('should_return_postponed_when_code_is_postponed', () {
      expect(
        PushPrimingDecision.fromCode('postponed'),
        PushPrimingDecision.postponed,
      );
    });

    test('should_return_notDecided_when_code_is_null', () {
      expect(
        PushPrimingDecision.fromCode(null),
        PushPrimingDecision.notDecided,
      );
    });

    test('should_return_notDecided_when_code_is_unknown', () {
      expect(
        PushPrimingDecision.fromCode('garbage'),
        PushPrimingDecision.notDecided,
      );
    });
  });

  group('code', () {
    test('should_roundtrip_through_fromCode_for_all_values', () {
      for (final decision in PushPrimingDecision.values) {
        expect(PushPrimingDecision.fromCode(decision.code), decision);
      }
    });
  });
}
