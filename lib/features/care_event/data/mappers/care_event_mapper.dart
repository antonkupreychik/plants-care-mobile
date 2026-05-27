import '../../../../core/api/generated/models/care_event_response.dart';
import '../../../../core/api/generated/models/care_event_type.dart';
import '../../../../core/api/generated/models/create_care_event_request.dart';
import '../../../plant_card/domain/care_event_kind.dart';
import '../../domain/care_event_draft.dart';
import '../../domain/logged_care_event.dart';

/// Маппинг domain ↔ DTO для `POST /care-events` (MADR-002/007). Пишется руками,
/// сгенерированный код не правим.

/// domain [CareEventKind] → публичный DTO-enum [CareEventType].
///
/// [CareEventKind.unknown] не имеет публичного эквивалента (нельзя отправить):
/// возвращаем `null`, репозиторий превращает это в `ApiError.badRequest` —
/// наружу не бросаем (MADR-011).
CareEventType? careEventTypeFromKind(CareEventKind kind) => switch (kind) {
      CareEventKind.water => CareEventType.water,
      CareEventKind.spray => CareEventType.spray,
      CareEventKind.fertilize => CareEventType.fertilize,
      CareEventKind.unknown => null,
    };

/// Публичный DTO-enum [CareEventType] → domain [CareEventKind].
/// `$unknown` (нераспознанный backend-код) → [CareEventKind.unknown].
CareEventKind careEventKindFromType(CareEventType type) => switch (type) {
      CareEventType.water => CareEventKind.water,
      CareEventType.spray => CareEventKind.spray,
      CareEventType.fertilize => CareEventKind.fertilize,
      CareEventType.$unknown => CareEventKind.unknown,
    };

extension CareEventDraftMapper on CareEventDraft {
  /// Черновик → тело запроса. [dtoType] — уже валидированный (не-null) тип
  /// (валидацию делает репозиторий через [careEventTypeFromKind]).
  /// `performedAt` отправляем в UTC (backend хранит UTC).
  CreateCareEventRequest toRequest(CareEventType dtoType) =>
      CreateCareEventRequest(
        plantId: plantId,
        type: dtoType,
        performedAt: performedAtUtc.toUtc(),
        note: note,
        clientId: clientId,
      );
}

extension CareEventResponseMapper on CareEventResponse {
  /// Ответ backend → domain. `performedAt` нормализуем в UTC.
  LoggedCareEvent toDomain() => LoggedCareEvent(
        id: id,
        plantId: plantId,
        plantName: plantName,
        type: careEventKindFromType(type),
        performedAtUtc: performedAt.toUtc(),
        onTime: onTime,
        note: note,
        clientId: clientId,
      );
}
