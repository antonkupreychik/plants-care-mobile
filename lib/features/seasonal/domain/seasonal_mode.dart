/// Режим авто-подстройки ухода по сезонам (`/api/v1/me.seasonalMode`).
///
/// Доменный enum поверх сгенерированного `MeResponseSeasonalMode`. Маппинг
/// строки backend делает маппер data-слоя (MADR-002). Экран 35 показывает
/// режим как пояснение к тумблеру; запись режима в объём фичи не входит
/// (переключается только сам флаг `seasonalEnabled`).
enum SeasonalMode {
  /// Коэффициент к базовому интервалу (умножаем базовый интервал на сезонный
  /// множитель).
  multiplier,

  /// Фиксированные интервалы на сезон (лето/зима заданы явно).
  fixed,

  /// Нераспознанный backend-код (forward-compatible).
  unknown;

  /// Нормализует строку backend (`MULTIPLIER`/`FIXED`) в доменный [SeasonalMode].
  /// Неизвестное значение → [SeasonalMode.unknown] (UI даст нейтральный текст).
  static SeasonalMode fromApi(String? raw) => switch (raw) {
        'MULTIPLIER' => SeasonalMode.multiplier,
        'FIXED' => SeasonalMode.fixed,
        _ => SeasonalMode.unknown,
      };
}
