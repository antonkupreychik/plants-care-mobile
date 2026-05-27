/// Предпочтение освещённости вида (источник — `SpeciesSummaryDto.lightPreference`,
/// строка `LightPreference.name()` backend, напр. `BRIGHT_INDIRECT`).
///
/// Контракт не фиксирует полный перечень значений (api-contract §10 даёт лишь
/// пример `BRIGHT_INDIRECT`), поэтому набор веток — по типичной доменной модели
/// освещённости. Любой нераспознанный код backend схлопывается в [unknown]
/// (не падаем). Domain-enum, маппинг из строки — в data-слое.
enum LightPreference {
  /// Прямое яркое солнце.
  fullSun,

  /// Яркий рассеянный свет.
  brightIndirect,

  /// Полутень / умеренный свет.
  partialShade,

  /// Тень / низкая освещённость.
  shade,

  /// Backend прислал неизвестный код или поле отсутствует.
  unknown,
}
