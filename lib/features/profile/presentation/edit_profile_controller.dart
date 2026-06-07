import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/profile_repository_provider.dart';
import 'edit_profile_state.dart';
import 'profile_summary_provider.dart';

part 'edit_profile_controller.g.dart';

/// Контроллер экрана «Редактировать профиль».
///
/// Контракт для UI:
/// - провайдер `editProfileControllerProvider` →
///   `AsyncValue<EditProfileState>`.
/// - `build` грузит `GET /api/v1/me` через [ProfileRepository.getEditDraft]
///   и инициализирует черновик.
/// - методы [setQuietHoursStart], [setQuietHoursEnd], [setTimezone] —
///   обновляют черновик, в сеть не ходят.
/// - [submit] — отправляет `PATCH /api/v1/me`, при успехе инвалидирует
///   [profileSummaryProvider], ставит `success`.
@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  Future<EditProfileState> build() async {
    final result =
        await ref.watch(profileRepositoryProvider).getEditDraft();
    final draft = switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
    return EditProfileState(initial: draft, draft: draft);
  }

  /// Обновляет начало тихих часов в черновике.
  void setQuietHoursStart(String value) =>
      _edit((s) => s.copyWith(draft: s.draft.copyWith(quietHoursStart: value)));

  /// Обновляет конец тихих часов в черновике.
  void setQuietHoursEnd(String value) =>
      _edit((s) => s.copyWith(draft: s.draft.copyWith(quietHoursEnd: value)));

  /// Обновляет таймзону в черновике.
  void setTimezone(String value) =>
      _edit((s) => s.copyWith(draft: s.draft.copyWith(timezone: value)));

  /// Отправляет изменения через `PATCH /api/v1/me`.
  ///
  /// При успехе инвалидирует [profileSummaryProvider] — шапка профиля
  /// перезагрузится с новыми данными.
  Future<void> submit() async {
    final current = state.value;
    if (current == null || !current.canSave) return;

    _edit((s) => s.copyWith(
          submitStatus: EditProfileSubmitStatus.submitting,
          submitError: null,
        ));

    final result = await ref
        .read(profileRepositoryProvider)
        .updateProfile(current.draft);

    switch (result) {
      case Success():
        ref.invalidate(profileSummaryProvider);
        _edit((s) => s.copyWith(
              submitStatus: EditProfileSubmitStatus.success,
            ));
      case Failure(:final error):
        _edit((s) => s.copyWith(
              submitStatus: EditProfileSubmitStatus.failure,
              submitError: error,
            ));
    }
  }

  /// Применяет [updater] к текущему значению `state`, если оно загружено.
  void _edit(EditProfileState Function(EditProfileState) updater) {
    final current = state.value;
    if (current != null) {
      state = AsyncData(updater(current));
    }
  }
}
