import 'package:freezed_annotation/freezed_annotation.dart';

import '../../plant_card/domain/care_event_kind.dart';

part 'logged_care_event.freezed.dart';

/// Результат успешной регистрации ухода (`CareEventResponse` → domain).
///
/// Возвращается из репозитория после `POST /care-events`. UI может показать
/// подтверждение (например, «в срок» по [onTime]). Тип — публичный
/// [CareEventKind] (тот же enum, что в истории и в черновике).
@freezed
abstract class LoggedCareEvent with _$LoggedCareEvent {
  const factory LoggedCareEvent({
    /// Идентификатор записи `care_history`.
    required int id,
    required int plantId,
    required String plantName,
    required CareEventKind type,

    /// Момент выполнения в UTC (как вернул backend).
    required DateTime performedAtUtc,

    /// Выполнено до дедлайна расписания (влияет на стрик).
    required bool onTime,
    String? note,

    /// Эхо clientId идемпотентности (если был передан).
    String? clientId,
  }) = _LoggedCareEvent;
}
