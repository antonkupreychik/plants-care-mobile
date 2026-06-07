// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(EditProfileController)
final editProfileControllerProvider = EditProfileControllerProvider._();

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
final class EditProfileControllerProvider
    extends $AsyncNotifierProvider<EditProfileController, EditProfileState> {
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
  EditProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editProfileControllerHash();

  @$internal
  @override
  EditProfileController create() => EditProfileController();
}

String _$editProfileControllerHash() =>
    r'182d682cdfa1b46c2a3b2a0ca55c392bd94dc36f';

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

abstract class _$EditProfileController
    extends $AsyncNotifier<EditProfileState> {
  FutureOr<EditProfileState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<EditProfileState>, EditProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditProfileState>, EditProfileState>,
              AsyncValue<EditProfileState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
