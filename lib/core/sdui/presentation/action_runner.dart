import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../features/care_event/domain/care_event_draft.dart';
import '../../../features/care_event/presentation/care_event_providers.dart';
import '../../../features/home/presentation/home_providers.dart';
import '../../../features/plant_card/domain/care_event_kind.dart';
import '../../../features/plant_card/presentation/plant_card_providers.dart';
import '../../clock/clock_provider.dart';
import '../../error/result.dart';
import '../../router/app_router.dart';
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
/// После успеха инвалидирует затронутые чтения ДЕКЛАРАТИВНО (MADR-017): по
/// логическим ключам [SduiAction.invalidates] (`home`/`today`/`plant`), которые
/// маппятся в провайдеры в [_invalidateByKeys] — вместо прежнего хардкода
/// набора провайдеров.
class ActionRunner {
  ActionRunner(this._ref);

  final Ref _ref;

  static const Uuid _uuid = Uuid();

  /// Исполняет [action]. Возвращает [SduiActionResult].
  Future<SduiActionResult> run(SduiAction action) async {
    return switch (action.kind) {
      SduiActionKind.logCare => _runLogCare(action),
      SduiActionKind.navigate => _runNavigate(action),
      SduiActionKind.unknown => () {
          // Неизвестный/новый kind — клиент его не исполняет (graceful).
          developer.log(
            'unsupported SDUI action kind (ignored)',
            name: 'ActionRunner',
          );
          return SduiActionResult.unsupported;
        }(),
    };
  }

  /// Навигация по [SduiAction.target] через go_router (`appRouterProvider`).
  /// Роутер берётся из графа провайдеров — `ActionRunner` не нуждается в
  /// `BuildContext`. Пустой/отсутствующий `target` → no-op + лог (graceful, не
  /// краш): сервер прислал битое действие, UI не реагирует ошибкой.
  SduiActionResult _runNavigate(SduiAction action) {
    final target = action.target;
    if (target == null || target.isEmpty) {
      developer.log(
        'navigate action without target (ignored)',
        name: 'ActionRunner',
      );
      return SduiActionResult.unsupported;
    }
    _ref.read(appRouterProvider).push(target);
    return SduiActionResult.success;
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
          _invalidateByKeys(action.invalidates, plantId);
          return SduiActionResult.success;
        }(),
      Failure() => SduiActionResult.failure,
    };
  }

  /// Декларативная инвалидация после успеха (MADR-017): вместо ХАРДКОДА ключей
  /// инвалидируем по логическим ключам [SduiAction.invalidates], маппя каждый в
  /// провайдер(ы). Неизвестный ключ → пропуск + лог (forward-compat). Ключ
  /// `plant` требует [plantId] из payload — без него тихо пропускаем.
  ///
  /// Идемпотентность care-event (`clientId`) сохраняется — она в самом drafт'е,
  /// инвалидация лишь перечитывает затронутые чтения.
  void _invalidateByKeys(List<String> keys, int plantId) {
    for (final key in keys) {
      switch (key) {
        case 'home':
          // Серверный SDUI-лейаут — сервер пересоберёт блоки
          // (`today_summary`, доступность действий).
          _ref.invalidate(homeScreenLayoutProvider);
        case 'today':
          // `GET /today`: и Home-карточка, и экран «Сегодня» (todayView
          // дериватив homeTasksList ← homeTasks).
          _ref.invalidate(homeTasksProvider);
        case 'plant':
          // Карточка растения + история/стрик. Требует plantId из payload.
          _ref
            ..invalidate(plantDetailProvider(plantId))
            ..invalidate(plantHistoryProvider(plantId))
            ..invalidate(plantCardHistoryProvider(plantId))
            ..invalidate(plantStreakProvider(plantId));
        default:
          developer.log(
            'unknown invalidate key "$key" (skipped)',
            name: 'ActionRunner',
          );
      }
    }
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
