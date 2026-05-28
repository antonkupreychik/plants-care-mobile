/// Зона здоровья растения (G1) — производная от `score`, посчитана backend.
///
/// Источник — поле `zone` ответа `GET /plants/{id}/health` (`GREEN`/`YELLOW`/
/// `RED`). Чистый Dart: маппинг строки backend в [HealthZone] лежит здесь
/// ([fromApi]), а явный перевод сгенерированного DTO-enum'а — в data-маппере
/// (MADR-002/007).
enum HealthZone {
  green,
  yellow,
  red;

  /// Маппинг строкового значения backend (`GREEN`/`YELLOW`/`RED`) в [HealthZone].
  ///
  /// Неизвестное/новое значение (если backend добавит зону) трактуем как
  /// [HealthZone.green] — нейтрально и не кидаем: деградация мягкая, экран не
  /// падает. Достоверность всё равно контролируется `insufficientData`.
  static HealthZone fromApi(String value) => switch (value) {
        'GREEN' => HealthZone.green,
        'YELLOW' => HealthZone.yellow,
        'RED' => HealthZone.red,
        _ => HealthZone.green,
      };
}
