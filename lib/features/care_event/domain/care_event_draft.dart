import 'package:freezed_annotation/freezed_annotation.dart';

import '../../plant_card/domain/care_event_kind.dart';

part 'care_event_draft.freezed.dart';

/// Черновик действия ухода для `POST /api/v1/care-events` (экран 06 sheet).
///
/// Чистый Dart, иммутабельный (freezed). Это намерение пользователя «отметить
/// уход», ещё не отправленное на backend. Data-слой маппит его в
/// `CreateCareEventRequest` (см. `CareEventDraftMapper`).
///
/// Тип ухода — [CareEventKind] из domain фичи `plant_card` (тот же публичный
/// enum `WATER/SPRAY/FERTILIZE`, что отдаёт история и принимает POST — не
/// дублируем). Значение [CareEventKind.unknown] здесь невалидно: его нельзя
/// выбрать в UI и нельзя отправить — маппер это отсекает.
///
/// Поля времени — в UTC (FLUTTER.md «Время»; backend хранит UTC). Дефолтное
/// «сейчас» НЕ зашито в модель: его подставляет presentation-слой из
/// `clockProvider`. Модель допускает [performedAt] в прошлом — backdating
/// разрешён контрактом (api-contract §7).
///
/// [clientId] — UUID идемпотентности: генерируется ОДИН раз на попытку отправки
/// (не на каждый build), чтобы ретрай слал тот же и backend дедуплицировал
/// (FLUTTER.md «Идемпотентность»). На уровне черновика-формы он null;
/// проставляется в момент `submit()`.
@freezed
abstract class CareEventDraft with _$CareEventDraft {
  const factory CareEventDraft({
    /// Растение, для которого отмечается уход.
    required int plantId,

    /// Выбранный тип ухода. `unknown` невалиден для отправки.
    required CareEventKind type,

    /// Момент выполнения в UTC. По умолчанию — «сейчас» (ставит presentation),
    /// допускается прошлое (backdating).
    required DateTime performedAtUtc,

    /// Необязательная заметка.
    String? note,

    /// UUID идемпотентности; null до момента отправки.
    String? clientId,
  }) = _CareEventDraft;
}
