import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/auth_repository_provider.dart';

part 'auth_verify_controller.g.dart';

/// Контроллер экрана проверки magic-link токена (deep link `/auth/verify`).
/// Family по [token] (значение из query-параметра ссылки).
///
/// Контракт для ui-builder:
/// - провайдер `authVerifyControllerProvider(token)` → `AsyncValue<void>`.
/// - `loading` — идёт обмен токена; `data` (`void`) — успех (сессия поднята,
///   router-guard сам перебросит, но экран обычно делает `context.go('/home')`);
///   `error` — [ApiError] (пустой/просроченный/использованный токен и пр.).
/// - пустой токен → сразу `AsyncError(ApiError.badRequest)` без сетевого вызова.
@riverpod
class AuthVerifyController extends _$AuthVerifyController {
  @override
  Future<void> build(String token) async {
    if (token.isEmpty) {
      throw const ApiError.badRequest();
    }
    final result =
        await ref.read(authRepositoryProvider).verifyMagicLink(token);
    switch (result) {
      case Success():
        return;
      case Failure(:final error):
        throw error;
    }
  }
}
