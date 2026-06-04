import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/auth_repository_provider.dart';
import 'auth_email_state.dart';

part 'auth_email_controller.g.dart';

/// Контроллер экрана запроса magic link (ввод email).
///
/// Контракт для ui-builder:
/// - провайдер `authEmailControllerProvider` → [AuthEmailState].
/// - [setEmail] — на каждый ввод (сбрасывает прошлую ошибку).
/// - [submit] — по кнопке «Получить ссылку»; no-op, если `!state.canSubmit`.
///   По успеху `linkSent = true` (UI рисует «проверьте почту»), по ошибке —
///   `error` заполнен.
@riverpod
class AuthEmailController extends _$AuthEmailController {
  @override
  AuthEmailState build() => const AuthEmailState();

  /// Обновляет email и сбрасывает ошибку (новый ввод — повод повторить).
  void setEmail(String email) {
    state = state.copyWith(email: email, error: null);
  }

  /// Запрашивает magic link на текущий email. No-op, если отправлять нельзя
  /// (невалидный email или запрос уже в полёте).
  Future<void> submit() async {
    if (!state.canSubmit) return;
    state = state.copyWith(submitting: true, error: null);

    final result =
        await ref.read(authRepositoryProvider).requestMagicLink(state.email);

    state = switch (result) {
      Success() => state.copyWith(submitting: false, linkSent: true),
      Failure(:final error) =>
        state.copyWith(submitting: false, error: error),
    };
  }
}
