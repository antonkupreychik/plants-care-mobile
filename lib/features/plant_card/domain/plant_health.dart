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
    /// `true`, если данных для достоверной оценки недостаточно (< 3 записей
    /// ухода). Тогда [score]/[zone] приходят `null`, а UI рисует нейтральное
    /// состояние («—»), а не подаёт число как точную метрику.
    required bool insufficientData,

    /// Индекс здоровья в диапазоне [0, 100]. `null`, если [insufficientData].
    int? score,

    /// Зона здоровья (цвет), производная от [score]. `null`, если
    /// [insufficientData].
    HealthZone? zone,
  }) = _PlantHealth;

  const PlantHealth._();

  /// Стоит ли показывать числовой [score] как достоверный.
  /// Удобный геттер для ui-builder: при недостатке данных или `null`-полях —
  /// `false` (тогда [score]!/[zone]! безопасно использовать только под `true`).
  bool get hasReliableScore => !insufficientData && score != null && zone != null;
}
