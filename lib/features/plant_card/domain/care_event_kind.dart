/// Тип события ухода в истории растения (`GET /plants/{id}/history`).
///
/// Backend в `CareEventResponse.type` отдаёт **публичный** enum
/// `WATER` / `SPRAY` / `FERTILIZE` (`CareEventType`, тот же, что в
/// `POST /care-events`) — это НЕ строковый `taskType` из `/today`
/// (`WATERING`/`MISTING`/`FERTILIZING`), см. BACKEND-GAPS G7. История
/// служебный `SOIL_CHECK` не отдаёт. Нормализацию делает маппер data-слоя
/// (MADR-002).
enum CareEventKind {
  water,
  spray,
  fertilize,

  /// Нераспознанный backend-код (контракт мог добавить тип) — UI рисует
  /// нейтрально, не падаем.
  unknown,
}
