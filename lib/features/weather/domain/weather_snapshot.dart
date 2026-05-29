import 'package:freezed_annotation/freezed_annotation.dart';

import 'watering_recommendation.dart';

part 'weather_snapshot.freezed.dart';

/// Доменная модель «Снапшот погоды» для Home (G4).
///
/// Источник — `GET /weather/snapshot` (`WeatherSnapshotResponse`). Все значения
/// посчитаны backend (влажность, рекомендация); клиент их НЕ пересчитывает
/// (FLUTTER.md «Время и расчёты»).
///
/// Когда [available] равно `false` (погода не настроена/источник недоступен),
/// все остальные поля приходят `null` — UI не показывает строку погоды (см.
/// [hasData]).
///
/// Чистый Dart, иммутабельна.
@freezed
abstract class WeatherSnapshot with _$WeatherSnapshot {
  const factory WeatherSnapshot({
    /// `true`, если данные погоды доступны (источник настроен и ответил).
    /// При `false` остальные поля — `null`.
    required bool available,

    /// Относительная влажность воздуха [0, 100]. `null`, если не [available].
    int? humidityPercent,

    /// Рекомендация backend по поливу. `null`, если не [available].
    WateringRecommendation? recommendation,

    /// Момент получения данных от источника (UTC). `null`, если не [available].
    DateTime? fetchedAt,

    /// `true`, если снапшот отдан из серверного кеша (~60 мин). `null`, если
    /// не [available].
    bool? fromCache,
  }) = _WeatherSnapshot;

  const WeatherSnapshot._();

  /// Стоит ли рисовать строку погоды на Home.
  ///
  /// Удобный геттер для ui-builder: `true` только когда погода доступна и есть
  /// влажность — тогда [humidityPercent]! безопасно использовать под `true`.
  bool get hasData => available && humidityPercent != null;
}
