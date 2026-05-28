/// Рекомендация backend по поливу (G4) — производная от текущей погоды.
///
/// Источник — поле `recommendation` ответа `GET /weather/snapshot`
/// (`DEFER_OK`/`DO_NOT_DEFER`/`NEUTRAL`). Чистый Dart: маппинг строки backend
/// в [WateringRecommendation] лежит здесь ([fromApi]), а явный перевод
/// сгенерированного DTO-enum'а — в data-маппере (MADR-002/007).
///
/// Значение посчитано backend; клиент рекомендацию НЕ пересчитывает.
enum WateringRecommendation {
  /// Можно отложить полив (`DEFER_OK`) — например, высокая влажность.
  deferOk,

  /// Откладывать полив не стоит (`DO_NOT_DEFER`).
  doNotDefer,

  /// Нейтрально (`NEUTRAL`) — погода не влияет на рекомендацию.
  neutral;

  /// Маппинг строкового значения backend в [WateringRecommendation].
  ///
  /// Неизвестное/новое значение (если backend добавит рекомендацию) трактуем
  /// как [WateringRecommendation.neutral] — нейтрально и не кидаем: деградация
  /// мягкая, экран не падает.
  static WateringRecommendation fromApi(String value) => switch (value) {
        'DEFER_OK' => WateringRecommendation.deferOk,
        'DO_NOT_DEFER' => WateringRecommendation.doNotDefer,
        'NEUTRAL' => WateringRecommendation.neutral,
        _ => WateringRecommendation.neutral,
      };
}
