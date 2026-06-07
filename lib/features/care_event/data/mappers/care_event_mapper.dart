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
      // SOIL_CHECK (issue #222) — служебная отметка проверки грунта; в domain
      // отдельного типа нет, схлопываем в unknown (UI рисует нейтрально).
      CareEventType.soilCheck => CareEventKind.unknown,
      CareEventType.$unknown => CareEventKind.unknown,
    };

extension CareEventDraftMapper on CareEventDraft {
  /// Черновик → тело запроса. [dtoType] — уже валидированный (не-null) тип
  /// (валидацию делает репозиторий через [careEventTypeFromKind]).
  /// `performedAt` отправляем в UTC (backend хранит UTC).
  ///
  /// Поля [amountMl], [soilWasDry], [fertilizerName] кодируются в итоговую
  /// заметку вместе с [note] (свободным текстом пользователя). Это временный
  /// подход: когда backend добавит эти поля в `CreateCareEventRequest`,
  /// маппер обновится без изменений UI.
  CreateCareEventRequest toRequest(CareEventType dtoType) =>
      CreateCareEventRequest(
        plantId: plantId,
        type: dtoType,
        performedAt: performedAtUtc.toUtc(),
        note: _buildNote(),
        clientId: clientId,
      );

  /// Составляет итоговую заметку из полей-расширений и пользовательского [note].
  String? _buildNote() {
    final parts = <String>[];
    if (amountMl != null && amountMl! > 0) parts.add('$amountMl мл');
    if (soilWasDry) parts.add('грунт был сухой');
    if (fertilizerName != null && fertilizerName!.isNotEmpty) {
      parts.add('удобрение: $fertilizerName');
    }
    final userNote = note?.trim();
    if (userNote != null && userNote.isNotEmpty) parts.add(userNote);
    return parts.isEmpty ? null : parts.join('; ');
  }
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
