import '../../../../core/api/generated/models/care_event_response.dart';
import '../../../../core/api/generated/models/care_event_type.dart';
import '../../domain/care_event_kind.dart';
import '../../domain/care_history_entry.dart';

/// Маппинг [CareEventResponse] (`/plants/{id}/history`) → domain
/// [CareHistoryEntry] (MADR-002). Точка нормализации контракта.
///
/// `CareEventResponse.type` — сгенерированный enum [CareEventType]
/// (`WATER`/`SPRAY`/`FERTILIZE`/`$unknown`). Это публичный тип care-event,
/// НЕ строковый `taskType` из `/today` — здесь маппинг 1:1 в domain-enum,
/// неизвестное значение схлопывается в [CareEventKind.unknown] (не падаем).
extension CareEventResponseMapper on CareEventResponse {
  CareHistoryEntry toDomain() => CareHistoryEntry(
        id: id,
        plantId: plantId,
        plantName: plantName,
        kind: type.toKind(),
        performedAt: performedAt,
        onTime: onTime,
        note: note,
      );
}

extension on CareEventType {
  CareEventKind toKind() => switch (this) {
        CareEventType.water => CareEventKind.water,
        CareEventType.spray => CareEventKind.spray,
        CareEventType.fertilize => CareEventKind.fertilize,
        CareEventType.$unknown => CareEventKind.unknown,
      };
}
