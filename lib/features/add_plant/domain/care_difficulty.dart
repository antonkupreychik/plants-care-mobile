/// Сложность ухода за видом (`SpeciesSummaryDto.careDifficulty`).
///
/// Backend отдаёт имя enum'а `CareDifficulty.name()` — строки `EASY` / `MEDIUM`
/// / `HARD`. Нормализацию строки в этот domain-enum делает маппер data-слоя
/// (MADR-002), по образцу `CareTaskType.fromApi`.
enum CareDifficulty {
  easy,
  medium,
  hard,

  /// Нераспознанный backend-код (контракт мог добавить уровень) — UI рисует
  /// нейтрально, не падаем.
  unknown;

  /// Маппинг строкового `careDifficulty` из backend в domain-enum.
  /// `null`/неизвестное значение → [CareDifficulty.unknown] (не бросаем).
  static CareDifficulty fromApi(String? raw) => switch (raw?.toUpperCase()) {
        'EASY' => CareDifficulty.easy,
        'MEDIUM' => CareDifficulty.medium,
        'HARD' => CareDifficulty.hard,
        _ => CareDifficulty.unknown,
      };
}
