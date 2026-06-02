import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository_provider.dart';
import '../domain/social_auth_outcome.dart';
import 'auth_social_state.dart';

part 'auth_social_controller.g.dart';

/// Контроллер кнопок социального входа (Google / Apple).
///
/// Контракт для ui-builder:
/// - провайдер `authSocialControllerProvider` → [AuthSocialState];
/// - [google] / [apple] — по нажатию соответствующей кнопки; no-op, если запрос
///   уже в полёте ([AuthSocialState.isBusy]). На время запроса
///   `inProgress` = провайдер (UI рисует индикатор и блокирует кнопки).
/// - По успеху контроллер ничего не навигирует — router-guard уведёт с экрана
///   входа сам (сессия уже поднята); `inProgress` сбрасывается.
/// - Отмена пользователем — тихий сброс `inProgress`, ошибка НЕ показывается.
/// - Ошибка — `error` заполнен, `inProgress` сброшен.
@riverpod
class AuthSocialController extends _$AuthSocialController {
  @override
  AuthSocialState build() => const AuthSocialState();

  /// Вход через Google. No-op, если уже идёт запрос.
  Future<void> google() => _run(
        SocialProvider.google,
        () => ref.read(authRepositoryProvider).signInWithGoogle(),
      );

  /// Вход через Apple (iOS). No-op, если уже идёт запрос.
  Future<void> apple() => _run(
        SocialProvider.apple,
        () => ref.read(authRepositoryProvider).signInWithApple(),
      );

  /// Общий сценарий: выставить `inProgress`, выполнить вход, разложить исход.
  Future<void> _run(
    SocialProvider provider,
    Future<SocialAuthOutcome> Function() action,
  ) async {
    if (state.isBusy) return;
    state = state.copyWith(inProgress: provider, error: null);

    final outcome = await action();

    state = switch (outcome) {
      // Успех: сессия поднята, гард уведёт; просто гасим прогресс.
      SocialAuthSuccess() => state.copyWith(inProgress: null),
      // Отмена: тихо, без ошибки.
      SocialAuthCancelled() => state.copyWith(inProgress: null),
      // Ошибка: показываем и гасим прогресс.
      SocialAuthFailure(:final error) =>
        state.copyWith(inProgress: null, error: error),
    };
  }
}
