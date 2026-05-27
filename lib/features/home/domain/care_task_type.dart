/// Тип задачи ухода в выдаче `/today` (и `/calendar`).
///
/// Backend отдаёт строки `WATERING` / `MISTING` / `FERTILIZING` / `SOIL_CHECK`
/// (поле `TaskDto.taskType`). Это НЕ то же, что enum `POST /care-events`
/// (`WATER` / `SPRAY` / `FERTILIZE`) — см. BACKEND-GAPS G7. Нормализацию
/// строки в этот enum делает маппер data-слоя (MADR-002).
enum CareTaskType {
  watering,
  misting,
  fertilizing,
  soilCheck,
  /// Нераспознанный backend-код (контракт мог добавить тип) — UI рисует
  /// нейтрально, не падаем.
  unknown;

  /// Маппинг строкового `taskType` из backend в domain-enum.
  /// Неизвестное значение → [CareTaskType.unknown] (не бросаем).
  static CareTaskType fromApi(String raw) => switch (raw.toUpperCase()) {
        'WATERING' => CareTaskType.watering,
        'MISTING' => CareTaskType.misting,
        'FERTILIZING' => CareTaskType.fertilizing,
        'SOIL_CHECK' => CareTaskType.soilCheck,
        _ => CareTaskType.unknown,
      };
}
