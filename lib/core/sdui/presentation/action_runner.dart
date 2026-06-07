import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../features/care_event/domain/care_event_draft.dart';
import '../../../features/care_event/presentation/care_event_providers.dart';
import '../../../features/home/presentation/home_providers.dart';
import '../../../features/plant_card/domain/care_event_kind.dart';
import '../../../features/plant_card/presentation/plant_card_providers.dart';
import '../../clock/clock_provider.dart';
import '../../error/result.dart';
import '../domain/sdui_action.dart';
import 'screen_layout_provider.dart';

part 'action_runner.g.dart';

/// Результат исполнения SDUI-действия (`ActionRunner`).
enum SduiActionResult {
  /// Действие выполнено успешно (затронутые провайдеры инвалидированы).
  success,

  /// Действие не выполнено (ошибка backend/сети).
  failure,

  /// Действие не поддерживается клиентом (неизвестный `kind` / нет данных).
  /// UI не реагирует ошибкой — graceful degradation.
  unsupported,
}

/// Исполнитель декларативных SDUI-действий ([SduiAction], MADR-015).
///
/// Сопоставляет [SduiActionKind] с НАТИВНЫМ флоу, а не изобретает свой сетевой
/// путь (FLUTTER.md / MADR-015): для [SduiActionKind.logCare] переиспользует
/// существующий care-event use case (`POST /care-events`) — тот же путь, что
/// sheet ухода.
///
/// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на вызов [run]
/// (не на каждый build), чтобы ретрай той же попытки слал тот же clientId и
/// backend дедуплицировал (FLUTTER.md «Идемпотентность»).
///
/// После успеха инвалидирует затронутые чтения (как care-event sheet): сводку
/// `today`, карточку растения, историю/стрик и — дополнительно для SDUI — сам
/// серверный лейаут ([homeScreenLayoutProvider]), чтобы сервер пересобрал блоки
/// (`today_summary`, доступность действий).
class ActionRunner {
  ActionRunner(this._ref);

  final Ref _ref;

  static const Uuid _uuid = Uuid();

  /// Исполняет [action]. Возвращает [SduiActionResult].
  Future<SduiActionResult> run(SduiAction action) async {
    return switch (action.kind) {
      SduiActionKind.logCare => _runLogCare(action),
      SduiActionKind.unknown => SduiActionResult.unsupported,
    };
  }

  Future<SduiActionResult> _runLogCare(SduiAction action) async {
    final payload = action.payload;
    final plantId = (payload?['plantId'] as num?)?.toInt();
    final kind = _kindFromPayload(payload?['type']);
    // Без plantId/валидного типа отправлять нечего — тихо «не поддержано».
    if (plantId == null || kind == CareEventKind.unknown) {
      return SduiActionResult.unsupported;
    }

    // Один clientId на действие (идемпотентность). Время «сейчас» — из
    // clockProvider (UTC), не DateTime.now() (FLUTTER.md «Время»).
    final draft = CareEventDraft(
      plantId: plantId,
      type: kind,
      performedAtUtc: _ref.read(clockProvider).nowUtc(),
      clientId: _uuid.v4(),
    );

    final result = await _ref.read(logCareEventProvider).call(draft);
    return switch (result) {
      Success() => () {
          _invalidateAfterSuccess(plantId);
          return SduiActionResult.success;
        }(),
      Failure() => SduiActionResult.failure,
    };
  }

  /// Инвалидация затронутых чтений после успеха (как care-event sheet,
  /// FLUTTER.md «Правила state»), плюс серверный SDUI-лейаут — чтобы сервер
  /// пересобрал блоки (`today_summary` и доступность действий).
  void _invalidateAfterSuccess(int plantId) {
    _ref
      ..invalidate(homeScreenLayoutProvider)
      ..invalidate(homeTasksProvider)
      ..invalidate(plantDetailProvider(plantId))
      ..invalidate(plantHistoryProvider(plantId))
      ..invalidate(plantCardHistoryProvider(plantId))
      ..invalidate(plantStreakProvider(plantId));
  }

  /// Публичный тип ухода из payload (`WATER`/`SPRAY`/`FERTILIZE`) → domain.
  /// Любое иное/отсутствующее значение → [CareEventKind.unknown].
  CareEventKind _kindFromPayload(Object? raw) => switch (raw) {
        'WATER' => CareEventKind.water,
        'SPRAY' => CareEventKind.spray,
        'FERTILIZE' => CareEventKind.fertilize,
        _ => CareEventKind.unknown,
      };
}

/// DI-точка [ActionRunner] (MADR-004: граф провайдеров = DI). Виджеты берут его
/// через `ref.read(actionRunnerProvider)` в колбэке действия.
@riverpod
ActionRunner actionRunner(Ref ref) => ActionRunner(ref);
