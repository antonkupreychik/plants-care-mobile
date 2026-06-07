import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/auth_repository_provider.dart';
import '../domain/social_auth_outcome.dart';
import 'convert_guest_state.dart';

part 'convert_guest_controller.g.dart';

/// Контроллер экрана конвертации гостевого аккаунта.
///
/// Контракт для ui-builder:
/// - провайдер `convertGuestControllerProvider` → [ConvertGuestState];
/// - [convertWithEmail] — конвертация через email magic-link;
/// - [convertWithGoogle] / [convertWithApple] — социальные провайдеры;
/// - По успеху Google/Apple: router-guard сам уведёт, `status = converted`;
///   инвалидирует [meIsGuestProvider] чтобы баннер исчез.
/// - По email success: `status = emailSent` (показываем «проверьте почту»).
/// - При ошибке: `error` заполнен, `inProgress` сброшен.
@riverpod
class ConvertGuestController extends _$ConvertGuestController {
  @override
  ConvertGuestState build() => const ConvertGuestState();

  /// Конвертировать через email magic-link. No-op, если уже идёт запрос.
  Future<void> convertWithEmail(String email) async {
    if (state.isBusy) return;
    state = state.copyWith(
      inProgress: ConvertProvider.email,
      error: null,
      email: email,
    );

    final result =
        await ref.read(authRepositoryProvider).convertGuestWithEmail(email);

    state = switch (result) {
      Success() => state.copyWith(
          inProgress: null,
          status: ConvertStatus.emailSent,
        ),
      Failure(:final error) => state.copyWith(
          inProgress: null,
          error: error,
        ),
    };
  }

  /// Конвертировать через Google. No-op, если уже идёт запрос.
  Future<void> convertWithGoogle() async {
    if (state.isBusy) return;
    state = state.copyWith(inProgress: ConvertProvider.google, error: null);

    final outcome =
        await ref.read(authRepositoryProvider).convertGuestWithGoogle();

    state = switch (outcome) {
      SocialAuthSuccess() => state.copyWith(
          inProgress: null,
          status: ConvertStatus.converted,
        ),
      SocialAuthCancelled() => state.copyWith(inProgress: null),
      SocialAuthFailure(:final error) => state.copyWith(
          inProgress: null,
          error: error,
        ),
    };
  }

  /// Конвертировать через Apple. No-op, если уже идёт запрос.
  Future<void> convertWithApple() async {
    if (state.isBusy) return;
    state = state.copyWith(inProgress: ConvertProvider.apple, error: null);

    final outcome =
        await ref.read(authRepositoryProvider).convertGuestWithApple();

    state = switch (outcome) {
      SocialAuthSuccess() => state.copyWith(
          inProgress: null,
          status: ConvertStatus.converted,
        ),
      SocialAuthCancelled() => state.copyWith(inProgress: null),
      SocialAuthFailure(:final error) => state.copyWith(
          inProgress: null,
          error: error,
        ),
    };
  }
}
