import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/auth_repository_provider.dart';
import 'auth_guest_state.dart';

part 'auth_guest_controller.g.dart';

/// Контроллер кнопки «Продолжить без аккаунта».
///
/// Контракт для ui-builder:
/// - провайдер `authGuestControllerProvider` → [AuthGuestState];
/// - [signInAsGuest] — по нажатию кнопки; no-op, если запрос уже в полёте.
/// - По успеху контроллер не навигирует — router-guard сам уведёт с экрана
///   входа (сессия поднята).
/// - При ошибке — [AuthGuestState.error] заполняется (показываем snackbar).
@riverpod
class AuthGuestController extends _$AuthGuestController {
  @override
  AuthGuestState build() => const AuthGuestState();

  /// Войти как гость. No-op если уже идёт запрос.
  Future<void> signInAsGuest() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    final result = await ref.read(authRepositoryProvider).signInAsGuest();

    state = switch (result) {
      Success() => state.copyWith(isLoading: false),
      Failure(:final error) => state.copyWith(isLoading: false, error: error),
    };
  }
}
