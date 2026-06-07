import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../auth/data/auth_repository_provider.dart';
import '../data/profile_repository_provider.dart';

part 'delete_account_notifier.g.dart';

/// Состояние процесса удаления аккаунта.
///
/// Первоначальный false — ничего не происходит; во время вызова — loading;
/// по завершению — success или error (через AsyncError).
@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Удаляет аккаунт: вызов `DELETE /api/v1/me`, затем очищает локальные
  /// данные/токены и выходит на экран Welcome через router-guard.
  ///
  /// При сетевой ошибке переходит в [AsyncError] с [ApiError] — UI рисует
  /// снэкбар.
  Future<void> deleteAccount() async {
    state = const AsyncLoading();

    final result = await ref.read(profileRepositoryProvider).deleteAccount();
    switch (result) {
      case Success():
        // Очищаем локальные данные/токены; router-guard после этого уведёт на
        // `/auth/welcome` автоматически (MADR-008).
        await ref.read(authRepositoryProvider).signOut();
        // Состояние после signOut не важно — роутер уже сделал redirect.
        state = const AsyncData(null);
      case Failure(:final error):
        state = AsyncError(error, StackTrace.current);
    }
  }
}
