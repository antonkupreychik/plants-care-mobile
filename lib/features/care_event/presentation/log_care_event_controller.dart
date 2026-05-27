import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/result.dart';
// Кросс-фичевая инвалидация после успешного POST (FLUTTER.md «Правила state» /
// README §5). Импортируем именно presentation-провайдеры состояния home и
// plant_card — это осознанное исключение из правила «фича не импортит
// presentation другой фичи» (см. шапку метода [_invalidateAfterSuccess]).
import '../../home/presentation/home_providers.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/presentation/plant_card_providers.dart';
import 'care_event_form_state.dart';
import 'care_event_providers.dart';

part 'log_care_event_controller.g.dart';

/// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
///
/// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
/// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
/// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
/// бизнес-логики в виджете нет (MADR-002).
///
/// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
/// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
/// прошлой датой (api-contract §7 разрешает).
///
/// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
/// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
/// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
/// новая попытка с новым clientId.
@riverpod
class LogCareEventController extends _$LogCareEventController {
  static const Uuid _uuid = Uuid();

  /// Сохранённый clientId текущей «попытки отправки». Сбрасывается в null после
  /// успеха и при ручном изменении формы (см. [_resetIdempotency]).
  String? _attemptClientId;

  @override
  CareEventFormState build(int plantId, {CareEventKind? presetType}) {
    return CareEventFormState(
      plantId: plantId,
      type: _validPreset(presetType),
      performedAtUtc: ref.read(clockProvider).nowUtc(),
    );
  }

  /// Выбрать тип ухода. `unknown` игнорируется (не выбираемый в UI).
  void setType(CareEventKind type) {
    if (type == CareEventKind.unknown) return;
    _resetIdempotency();
    state = state.copyWith(type: type, status: const CareEventSubmitStatus.idle());
  }

  /// Задать момент выполнения (UTC). Для backdating UI передаёт прошлую дату.
  void setPerformedAt(DateTime performedAtUtc) {
    _resetIdempotency();
    state = state.copyWith(
      performedAtUtc: performedAtUtc.toUtc(),
      status: const CareEventSubmitStatus.idle(),
    );
  }

  /// Обновить заметку (null/пусто → без заметки).
  void setNote(String? note) {
    _resetIdempotency();
    final trimmed = note?.trim();
    state = state.copyWith(
      note: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      status: const CareEventSubmitStatus.idle(),
    );
  }

  /// Отправить отметку (`POST /care-events`). Идемпотентно по clientId попытки.
  ///
  /// Возвращает `true` при успехе (UI может закрыть sheet). На успех —
  /// кросс-фичевая инвалидация ([_invalidateAfterSuccess]). На ошибку —
  /// типизированный [ApiError] кладётся в `status` (UI рисует по типу).
  Future<bool> submit() async {
    if (!state.canSubmit) return false;

    // Один clientId на попытку: если это ретрай той же попытки — тот же UUID.
    final clientId = _attemptClientId ??= _uuid.v4();

    state = state.copyWith(status: const CareEventSubmitStatus.submitting());

    final draft = state.toDraft(clientId: clientId);
    final result = await ref.read(logCareEventProvider).call(draft);

    // Sheet — autoDispose family поверх showModalBottomSheet: если пользователь
    // смахнул sheet во время in-flight POST, notifier диспоузнулся и обращение к
    // ref/state ниже кинуло бы StateError (Future от submit UI отбрасывает).
    // Запись на бэке уже создана/создаётся — идемпотентность по clientId
    // покрывает повтор, sheet всё равно закрыт. Просто выходим.
    if (!ref.mounted) return false;

    switch (result) {
      case Success():
        _attemptClientId = null;
        _invalidateAfterSuccess(state.plantId);
        state = state.copyWith(status: const CareEventSubmitStatus.success());
        return true;
      case Failure(:final error):
        // clientId НЕ сбрасываем: повторный submit ретраит ту же попытку.
        state = state.copyWith(status: CareEventSubmitStatus.failure(error));
        return false;
    }
  }

  /// Инвалидация затронутых чтений после успеха (FLUTTER.md «Правила state» /
  /// README §5). Импорт presentation-провайдеров другой фичи — осознанное
  /// исключение из границы слоёв: цель инвалидации — именно публичные
  /// провайдеры состояния home/plant_card, иного канала «сообщить, что данные
  /// устарели» в Riverpod нет. Зависим только от объявлений провайдеров, не от
  /// виджетов. Calendar-провайдер пока не существует — НЕ инвалидируем
  /// (добавить, когда фича calendar появится).
  void _invalidateAfterSuccess(int plantId) {
    ref
      ..invalidate(homeTasksProvider)
      ..invalidate(plantDetailProvider(plantId))
      ..invalidate(plantHistoryProvider(plantId))
      ..invalidate(plantStreakProvider(plantId));
  }

  /// Любое ручное изменение формы → следующий submit это новая попытка.
  void _resetIdempotency() => _attemptClientId = null;

  /// Пресет типа из задачи `/today` (если sheet открыт оттуда). `unknown`
  /// (например, маппинг SOIL_CHECK) откатывается на дефолт [CareEventKind.water].
  CareEventKind _validPreset(CareEventKind? presetType) =>
      (presetType == null || presetType == CareEventKind.unknown)
          ? CareEventKind.water
          : presetType;
}
