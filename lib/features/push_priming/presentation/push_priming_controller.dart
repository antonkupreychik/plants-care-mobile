import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/push_priming_repository_provider.dart';
import '../domain/push_priming_decision.dart';

part 'push_priming_controller.g.dart';

/// AsyncNotifier решения пользователя по праймингу пушей (экран 27).
///
/// Codegen (Riverpod 3) генерирует переменную **`pushPrimingControllerProvider`**.
///
/// Контракт для UI:
/// - `ref.watch(pushPrimingControllerProvider)` → `AsyncValue<PushPrimingDecision>`
/// - `ref.read(pushPrimingControllerProvider.notifier).allow()`
/// - `ref.read(pushPrimingControllerProvider.notifier).postpone()`
///
/// Реальный системный запрос разрешений и регистрация push-токена
/// (`POST /api/v1/devices`) здесь НЕ выполняются: они появятся отдельной
/// задачей после решения по push-стеку (README §9 #3) и эндпоинта backend #187.
/// Сейчас фиксируется только намерение пользователя (локальный персист).
@riverpod
class PushPrimingController extends _$PushPrimingController {
  @override
  Future<PushPrimingDecision> build() {
    return ref.watch(pushPrimingRepositoryProvider).getDecision();
  }

  /// Пользователь согласился получать уведомления.
  Future<void> allow() => _save(PushPrimingDecision.allowed);

  /// Пользователь отложил («Позже»/«Пропустить»).
  Future<void> postpone() => _save(PushPrimingDecision.postponed);

  Future<void> _save(PushPrimingDecision decision) async {
    if (state.isLoading) return;
    state = AsyncData(decision);
    await ref.read(pushPrimingRepositoryProvider).saveDecision(decision);
  }
}
