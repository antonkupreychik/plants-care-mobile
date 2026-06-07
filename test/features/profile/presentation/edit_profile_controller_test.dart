import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/profile/data/profile_repository_provider.dart';
import 'package:plantcare_mobile/features/profile/domain/edit_profile_draft.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_repository.dart';
import 'package:plantcare_mobile/features/profile/domain/profile_summary.dart';
import 'package:plantcare_mobile/features/profile/presentation/edit_profile_controller.dart';
import 'package:plantcare_mobile/features/profile/presentation/edit_profile_state.dart';

class _MockProfileRepo extends Mock implements ProfileRepository {}

final _mockDraft = EditProfileDraft(
  displayName: 'Антон',
  quietHoursStart: '22:00',
  quietHoursEnd: '08:00',
  timezone: 'Europe/Moscow',
);

ProfileSummary _profileSummary() => ProfileSummary(
      name: 'Антон',
      createdAt: DateTime.utc(2025, 1, 1),
      plantsTotal: 5,
    );

ProviderContainer _container(ProfileRepository profileRepo) {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(profileRepo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUp(() {
    registerFallbackValue(
      const EditProfileDraft(
        quietHoursStart: '22:00',
        quietHoursEnd: '08:00',
        timezone: 'UTC',
      ),
    );
  });

  group('EditProfileController.build', () {
    test('should_load_initial_state_from_getEditDraft', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));

      final container = _container(profileRepo);
      final state = await container.read(editProfileControllerProvider.future);

      expect(state.draft.quietHoursStart, '22:00');
      expect(state.draft.quietHoursEnd, '08:00');
      expect(state.draft.timezone, 'Europe/Moscow');
      expect(state.draft.displayName, 'Антон');
      expect(state.isDirty, isFalse);
    });

  });

  group('EditProfileController mutations', () {
    test('setQuietHoursStart_updates_draft', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));

      final container = _container(profileRepo);
      await container.read(editProfileControllerProvider.future);
      container
          .read(editProfileControllerProvider.notifier)
          .setQuietHoursStart('21:00');

      final updated = container.read(editProfileControllerProvider).value!;
      expect(updated.draft.quietHoursStart, '21:00');
      expect(updated.isDirty, isTrue);
    });

    test('setQuietHoursEnd_updates_draft', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));

      final container = _container(profileRepo);
      await container.read(editProfileControllerProvider.future);
      container
          .read(editProfileControllerProvider.notifier)
          .setQuietHoursEnd('07:00');

      final updated = container.read(editProfileControllerProvider).value!;
      expect(updated.draft.quietHoursEnd, '07:00');
    });

    test('setTimezone_updates_draft', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));

      final container = _container(profileRepo);
      await container.read(editProfileControllerProvider.future);
      container
          .read(editProfileControllerProvider.notifier)
          .setTimezone('Asia/Yekaterinburg');

      final updated = container.read(editProfileControllerProvider).value!;
      expect(updated.draft.timezone, 'Asia/Yekaterinburg');
    });
  });

  group('EditProfileController.submit', () {
    test('should_call_updateProfile_and_set_success', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));
      when(() => profileRepo.updateProfile(any())).thenAnswer(
        (_) async => Result.success(_profileSummary()),
      );
      // getSummary might be called when profileSummaryProvider is invalidated.
      when(profileRepo.getSummary)
          .thenAnswer((_) async => Result.success(_profileSummary()));

      final container = _container(profileRepo);
      await container.read(editProfileControllerProvider.future);

      // Make it dirty with a valid change.
      container
          .read(editProfileControllerProvider.notifier)
          .setQuietHoursStart('21:00');

      await container.read(editProfileControllerProvider.notifier).submit();

      final state = container.read(editProfileControllerProvider).value!;
      expect(state.submitStatus, EditProfileSubmitStatus.success);
      verify(() => profileRepo.updateProfile(any())).called(1);
    });

    test('should_set_failure_on_error', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));
      when(() => profileRepo.updateProfile(any())).thenAnswer(
        (_) async => const Result.failure(ApiError.unknown()),
      );

      final container = _container(profileRepo);
      await container.read(editProfileControllerProvider.future);
      container
          .read(editProfileControllerProvider.notifier)
          .setQuietHoursStart('21:00');

      await container.read(editProfileControllerProvider.notifier).submit();

      final state = container.read(editProfileControllerProvider).value!;
      expect(state.submitStatus, EditProfileSubmitStatus.failure);
      expect(state.submitError, const ApiError.unknown());
    });

    test('should_do_nothing_if_not_dirty', () async {
      final profileRepo = _MockProfileRepo();
      when(profileRepo.getEditDraft)
          .thenAnswer((_) async => Result.success(_mockDraft));

      final container = _container(profileRepo);
      await container.read(editProfileControllerProvider.future);
      // No changes — submit is a no-op.
      await container.read(editProfileControllerProvider.notifier).submit();

      verifyNever(() => profileRepo.updateProfile(any()));
    });
  });
}
