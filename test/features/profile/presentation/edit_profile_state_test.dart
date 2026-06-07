import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/profile/domain/edit_profile_draft.dart';
import 'package:plantcare_mobile/features/profile/presentation/edit_profile_state.dart';

EditProfileDraft _draft({
  String quietHoursStart = '22:00',
  String quietHoursEnd = '08:00',
  String timezone = 'Europe/Moscow',
}) =>
    EditProfileDraft(
      displayName: 'Антон',
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      timezone: timezone,
    );

void main() {
  group('EditProfileState.isDirty', () {
    test('should_be_false_when_draft_matches_initial', () {
      final d = _draft();
      final state = EditProfileState(initial: d, draft: d);
      expect(state.isDirty, isFalse);
    });

    test('should_be_true_when_quietHoursStart_changed', () {
      final initial = _draft();
      final draft = _draft(quietHoursStart: '21:00');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isDirty, isTrue);
    });

    test('should_be_true_when_quietHoursEnd_changed', () {
      final initial = _draft();
      final draft = _draft(quietHoursEnd: '07:00');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isDirty, isTrue);
    });

    test('should_be_true_when_timezone_changed', () {
      final initial = _draft();
      final draft = _draft(timezone: 'Asia/Yekaterinburg');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isDirty, isTrue);
    });
  });

  group('EditProfileState.isValid', () {
    test('should_be_true_for_valid_data', () {
      final d = _draft();
      final state = EditProfileState(initial: d, draft: d);
      expect(state.isValid, isTrue);
    });

    test('should_be_false_when_quietHoursStart_malformed', () {
      final initial = _draft();
      final draft = _draft(quietHoursStart: '25:00');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isValid, isFalse);
    });

    test('should_be_false_when_quietHoursEnd_malformed', () {
      final initial = _draft();
      final draft = _draft(quietHoursEnd: 'bad');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isValid, isFalse);
    });

    test('should_be_false_when_start_equals_end', () {
      final initial = _draft();
      final draft =
          _draft(quietHoursStart: '08:00', quietHoursEnd: '08:00');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isValid, isFalse);
    });

    test('should_be_false_when_timezone_empty', () {
      final initial = _draft();
      final draft = _draft(timezone: '');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.isValid, isFalse);
    });
  });

  group('EditProfileState.canSave', () {
    test('should_be_false_when_not_dirty', () {
      final d = _draft();
      final state = EditProfileState(initial: d, draft: d);
      expect(state.canSave, isFalse);
    });

    test('should_be_true_when_dirty_and_valid', () {
      final initial = _draft();
      final draft = _draft(quietHoursStart: '21:00');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.canSave, isTrue);
    });

    test('should_be_false_when_dirty_but_invalid', () {
      final initial = _draft();
      // Start changed but now equals end → invalid.
      final draft = _draft(quietHoursStart: '08:00');
      final state = EditProfileState(initial: initial, draft: draft);
      expect(state.canSave, isFalse);
    });
  });

  group('EditProfileState.isSubmitting', () {
    test('should_be_false_initially', () {
      final d = _draft();
      final state = EditProfileState(initial: d, draft: d);
      expect(state.isSubmitting, isFalse);
    });

    test('should_be_true_when_submitting', () {
      final d = _draft();
      final state = EditProfileState(
        initial: d,
        draft: d,
        submitStatus: EditProfileSubmitStatus.submitting,
      );
      expect(state.isSubmitting, isTrue);
    });
  });
}
