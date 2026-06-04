import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../domain/care_event_draft.dart';

part 'care_event_form_state.freezed.dart';

/// UI-состояние формы отметки ухода (экран 06 sheet).
///
/// Держит выбор пользователя ([type], [performedAtUtc], [note]) и статус
/// отправки ([status]). Это presentation-state (роль ViewModel) —
/// freezed-immutable, мутируется только через `LogCareEventController`.
///
/// Время — в UTC (FLUTTER.md «Время»). UI показывает в TZ пользователя и при
/// backdating передаёт обратно UTC. Дефолтное «сейчас» подставляет контроллер
/// из `clockProvider`, не виджет.
@freezed
abstract class CareEventFormState with _$CareEventFormState {
  const factory CareEventFormState({
    /// Растение, для которого отмечается уход.
    required int plantId,

    /// Выбранный тип ухода. `unknown` UI не предлагает (невалиден для отправки).
    required CareEventKind type,

    /// Момент выполнения в UTC. Дефолт — «сейчас», допускается прошлое.
    required DateTime performedAtUtc,

    /// Статус отправки (idle/submitting/success/failure).
    @Default(CareEventSubmitStatus.idle()) CareEventSubmitStatus status,

    /// Необязательная заметка.
    String? note,
  }) = _CareEventFormState;

  const CareEventFormState._();

  /// Можно ли отправлять: валидный тип и не идёт отправка.
  bool get canSubmit =>
      type != CareEventKind.unknown && status is! Submitting;
}

/// Статус отправки формы (sealed — UI матчит по типу, README §5/MADR-011).
@freezed
sealed class CareEventSubmitStatus with _$CareEventSubmitStatus {
  /// Ничего не отправляли / можно редактировать.
  const factory CareEventSubmitStatus.idle() = Idle;

  /// Идёт `POST /care-events` — UI блокирует кнопку, показывает прогресс.
  const factory CareEventSubmitStatus.submitting() = Submitting;

  /// Успех — UI закрывает sheet, показывает подтверждение.
  ///
  /// Несёт данные записанного события для пост-успешного флоу (экран 33
  /// «Успех первого ухода»):
  /// - [wasFirstCare] — это было ПЕРВОЕ событие ухода растения (детекция до
  ///   POST по `total` истории; при ошибке детекции — `false`, деградируем
  ///   тихо, без празднования);
  /// - [kind] — тип записанного ухода (для иллюстрации/копирайта экрана 33);
  /// - [onTime] — выполнено ли в срок (как вернул backend в `LoggedCareEvent`).
  ///
  /// Sheet читает это в listener на `status` и решает: push экрана 33
  /// (если [wasFirstCare]) или обычный снэкбар.
  const factory CareEventSubmitStatus.success({
    @Default(false) bool wasFirstCare,
    @Default(CareEventKind.water) CareEventKind kind,
    @Default(true) bool onTime,
  }) = SubmitSuccess;

  /// Ошибка — UI рисует баннер/тост по типу [error] (текст через l10n).
  const factory CareEventSubmitStatus.failure(ApiError error) = SubmitFailure;
}

/// Сборка domain-черновика из presentation-состояния (presentation → domain).
/// [clientId] подставляет контроллер в момент отправки (один на попытку).
extension CareEventFormStateMapper on CareEventFormState {
  CareEventDraft toDraft({required String clientId}) => CareEventDraft(
        plantId: plantId,
        type: type,
        performedAtUtc: performedAtUtc,
        note: note,
        clientId: clientId,
      );
}
