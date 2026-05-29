/// Категория справочного факта о виде (источник — `SpeciesFactDto.category`,
/// строка backend: `CARE` | `CURIOSITY` | `ORIGIN` | `TOXICITY` | …).
///
/// Перечень категорий на backend открытый (может прийти новый код), поэтому
/// domain-enum фиксирует лишь известные значения, а всё нераспознанное (или
/// `null`) схлопывается в [unknown] — UI рисует нейтрально, не падаем. Domain-
/// enum, НЕ тащим строку из DTO в presentation. Маппинг строки → этот enum
/// живёт в data-слое (`mappers/species_mapper.dart`).
enum SpeciesFactCategory {
  /// Уход.
  care,

  /// Интересный факт.
  curiosity,

  /// Родина / происхождение.
  origin,

  /// Токсичность (для людей/животных). По этому факту UI рисует баннер.
  toxicity,

  /// Backend прислал неизвестный код или поле отсутствует.
  unknown,
}
