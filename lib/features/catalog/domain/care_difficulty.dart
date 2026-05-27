/// Сложность ухода за видом (источник — `SpeciesSummaryDto.careDifficulty`,
/// строка `CareDifficulty.name()` backend: `EASY` | `MEDIUM` | `HARD`).
///
/// Domain-enum, НЕ тащим строку из DTO в presentation. Маппинг строки backend →
/// этот enum живёт в data-слое (`mappers/species_mapper.dart`). Нераспознанное
/// значение (или `null`) схлопывается в [unknown] — UI рисует нейтрально, не падаем.
enum CareDifficulty {
  easy,
  medium,
  hard,

  /// Backend прислал неизвестный код или поле отсутствует.
  unknown,
}
