import 'package:freezed_annotation/freezed_annotation.dart';

import 'care_event_kind.dart';

part 'care_history_entry.freezed.dart';

/// Доменная модель записи истории ухода (источник — `GET /plants/{id}/history`,
/// `CareEventResponse`).
///
/// Чистый Dart. Поле `clientId` (идемпотентность offline) для экрана 02 не нужно
/// и сознательно не переносится — карточка лишь читает историю.
@freezed
abstract class CareHistoryEntry with _$CareHistoryEntry {
  const factory CareHistoryEntry({
    required int id,
    required int plantId,
    required String plantName,

    /// Тип события ухода (нормализован из `CareEventResponse.type`).
    required CareEventKind kind,

    /// Момент выполнения ухода (UTC). UI показывает в TZ пользователя.
    required DateTime performedAt,

    /// Выполнено «в срок» — до дедлайна расписания (база для стрика).
    required bool onTime,

    /// Заметка пользователя к событию, если была.
    String? note,
  }) = _CareHistoryEntry;
}
