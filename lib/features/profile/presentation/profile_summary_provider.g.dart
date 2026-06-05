// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Сводка профиля для шапки и статистики экрана «Я» (`GET /api/v1/me`).
///
/// `AsyncValue` даёт экрану три состояния: loading (skeleton), error (тихая
/// деградация — шапка/статы скрыты, навигация работает), data. На ошибке
/// бросаем [ApiError] из [Result.failure], чтобы попасть в ветку
/// `AsyncValue.error` — экран её не показывает баннером, а просто прячет блок.

@ProviderFor(profileSummary)
final profileSummaryProvider = ProfileSummaryProvider._();

/// Сводка профиля для шапки и статистики экрана «Я» (`GET /api/v1/me`).
///
/// `AsyncValue` даёт экрану три состояния: loading (skeleton), error (тихая
/// деградация — шапка/статы скрыты, навигация работает), data. На ошибке
/// бросаем [ApiError] из [Result.failure], чтобы попасть в ветку
/// `AsyncValue.error` — экран её не показывает баннером, а просто прячет блок.

final class ProfileSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileSummary>,
          ProfileSummary,
          FutureOr<ProfileSummary>
        >
    with $FutureModifier<ProfileSummary>, $FutureProvider<ProfileSummary> {
  /// Сводка профиля для шапки и статистики экрана «Я» (`GET /api/v1/me`).
  ///
  /// `AsyncValue` даёт экрану три состояния: loading (skeleton), error (тихая
  /// деградация — шапка/статы скрыты, навигация работает), data. На ошибке
  /// бросаем [ApiError] из [Result.failure], чтобы попасть в ветку
  /// `AsyncValue.error` — экран её не показывает баннером, а просто прячет блок.
  ProfileSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSummaryHash();

  @$internal
  @override
  $FutureProviderElement<ProfileSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileSummary> create(Ref ref) {
    return profileSummary(ref);
  }
}

String _$profileSummaryHash() => r'937b7023dde10e7fc74abce30973b239f99713cc';
