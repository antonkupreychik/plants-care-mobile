import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/care/care_task.dart';
import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
// Кросс-фичевая инвалидация после успешного POST (FLUTTER.md «Правила state» /
// README §5): целимся в публичные провайдеры состояния home/plant_card —
// осознанное исключение из границы слоёв (тот же приём, что в
// LogCareEventController). Зависим от объявлений провайдеров, не от виджетов.
import '../../care_event/data/mappers/task_type_mapper.dart';
import '../../care_event/domain/care_event_draft.dart';
import '../../care_event/presentation/care_event_providers.dart';
import '../../home/presentation/home_providers.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/presentation/plant_card_providers.dart';
import 'schedule_day_view.dart';
import 'schedule_providers.dart';

part 'schedule_mark_controller.freezed.dart';
part 'schedule_mark_controller.g.dart';

/// Состояние оптимистичных отметок ухода экрана 11 «График».
///
/// Чистый иммутабельный снимок: какие задачи (по [scheduleTaskKeyOf]) уже
/// отмечены выполненными в текущей сессии ([doneKeys]), какие в процессе
/// отправки ([pendingKeys]), и ошибка последней неудачной отметки ([lastError]).
/// UI рисует строку «сделано» сразу (оптимистично), а ошибку показывает баннером
/// с откатом.
@freezed
abstract class ScheduleMarkState with _$ScheduleMarkState {
  const factory ScheduleMarkState({
    @Default(<ScheduleTaskKey>{}) Set<ScheduleTaskKey> doneKeys,
    @Default(<ScheduleTaskKey>{}) Set<ScheduleTaskKey> pendingKeys,
    ApiError? lastError,
  }) = _ScheduleMarkState;
}

/// Контроллер оптимистичной отметки ухода прямо из строки графика (экран 11).
///
/// В отличие от sheet 06 (`LogCareEventController`), здесь отметка одношаговая:
/// тап по кнопке-чеку → задача мгновенно уходит в «Сделано», параллельно
/// `POST /care-events`. На успех — кросс-фичевая инвалидация
/// ([_invalidateAfterSuccess], FLUTTER.md «Правила state»). На ошибку — откат
/// (задача возвращается из «Сделано») и [ScheduleMarkState.lastError] для
/// баннера.
///
/// Идемпотентность (FLUTTER.md): `clientId` генерируется ОДИН раз на действие
/// перед отправкой (не на каждый build) — повторный тап по уже отмеченной задаче
/// игнорируется (она в [ScheduleMarkState.doneKeys]/[pendingKeys]).
///
/// Время «сейчас» — из `clockProvider` (UTC), не `DateTime.now()` (FLUTTER.md
/// «Время»).
@riverpod
class ScheduleMarkController extends _$ScheduleMarkController {
  static const Uuid _uuid = Uuid();

  @override
  ScheduleMarkState build() => const ScheduleMarkState();

  /// Отметить задачу выполненной (оптимистично + `POST /care-events`).
  ///
  /// Тип задачи `/calendar` (`CareTaskType`) маппится в публичный
  /// [CareEventKind] для POST. `SOIL_CHECK`/`unknown` REST не принимает —
  /// такую задачу отметить нельзя (ранний выход), кнопка-чек для неё неактивна.
  Future<void> mark(CareTask task) async {
    final key = scheduleTaskKeyOf(task);
    // Уже отмечена или в полёте — повторный тап игнорируем (идемпотентность UI).
    if (state.doneKeys.contains(key) || state.pendingKeys.contains(key)) return;

    final kind = careEventKindFromTaskType(task.type);
    if (kind == CareEventKind.unknown) return; // нечего отправлять (SOIL_CHECK)

    // Оптимистично: строка сразу уходит в «Сделано».
    state = state.copyWith(
      doneKeys: {...state.doneKeys, key},
      pendingKeys: {...state.pendingKeys, key},
      lastError: null,
    );

    final draft = CareEventDraft(
      plantId: task.plantId,
      type: kind,
      performedAtUtc: ref.read(clockProvider).nowUtc(),
      clientId: _uuid.v4(),
    );

    final result = await ref.read(logCareEventProvider).call(draft);

    // Контроллер не autoDispose, но на всякий случай — после await проверяем
    // mounted, чтобы не трогать state выгруженного notifier.
    if (!ref.mounted) return;

    switch (result) {
      case Success():
        state = state.copyWith(
          pendingKeys: {...state.pendingKeys}..remove(key),
        );
        _invalidateAfterSuccess(task.plantId);
      case Failure(:final error):
        // Откат: задача возвращается из «Сделано», показываем ошибку.
        state = state.copyWith(
          doneKeys: {...state.doneKeys}..remove(key),
          pendingKeys: {...state.pendingKeys}..remove(key),
          lastError: error,
        );
    }
  }

  /// Сбросить ошибку (после показа баннера/повторной попытки).
  void clearError() {
    if (state.lastError == null) return;
    state = state.copyWith(lastError: null);
  }

  /// Инвалидация затронутых чтений после успеха (FLUTTER.md «Правила state» /
  /// README §5): `calendar` (текущая неделя), `today`, `plant(id)`,
  /// `plant(id).streak`. Импорт presentation-провайдеров других фич —
  /// осознанное исключение из границы слоёв (см. шапку файла).
  void _invalidateAfterSuccess(int plantId) {
    ref
      ..invalidate(scheduleWeekProvider)
      ..invalidate(homeTasksProvider)
      ..invalidate(plantDetailProvider(plantId))
      ..invalidate(plantStreakProvider(plantId));
  }
}
