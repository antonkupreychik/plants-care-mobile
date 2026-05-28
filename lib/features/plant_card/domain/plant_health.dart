import 'package:freezed_annotation/freezed_annotation.dart';

import 'health_zone.dart';

part 'plant_health.freezed.dart';

/// Доменная модель «Health Score» растения (G1).
///
/// Источник — `GET /plants/{id}/health` (`PlantHealthResponse`). Все значения
/// посчитаны backend; клиент их НЕ пересчитывает (FLUTTER.md «Время и расчёты»).
///
/// Чистый Dart, иммутабельна. Используется и на карточке растения (бейдж), и на
/// карточках Home-сетки (кольцо) через общий `plantHealthProvider(plantId)`.
@freezed
abstract class PlantHealth with _$PlantHealth {
  const factory PlantHealth({
    /// Индекс здоровья в диапазоне [0, 100].
    required int score,

    /// Зона здоровья (цвет), производная от [score].
    required HealthZone zone,

    /// `true`, если данных для достоверной оценки недостаточно. Тогда UI рисует
    /// нейтральное состояние («—»), а не подаёт [score] как точную метрику.
    required bool insufficientData,
  }) = _PlantHealth;

  const PlantHealth._();

  /// Стоит ли показывать числовой [score] как достоверный.
  /// Удобный геттер для ui-builder: при недостатке данных — `false`.
  bool get hasReliableScore => !insufficientData;
}
