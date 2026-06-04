/// Тип редкого разового события из жизни растения (журнал событий).
///
/// Чистый Dart (без Flutter/Riverpod). НЕ путать с регулярным уходом
/// (`CareEventKind`: WATER/SPRAY/FERTILIZE) — это контекстные факты на временной
/// шкале растения, которые backend хранит отдельно (`PlantEvent`, backend
/// issue #76; REST-контроллер — backend #220).
///
/// Значения [wireName] соответствуют enum backend (`TRANSPLANT`, `SOIL_CHANGE`,
/// `PRUNING`, `PEST_TREATMENT`) — маппер DTO↔domain опирается на них, а не на
/// порядок объявления.
enum PlantEventType {
  /// Пересадка (`TRANSPLANT`).
  transplant('TRANSPLANT'),

  /// Замена грунта (`SOIL_CHANGE`).
  soilChange('SOIL_CHANGE'),

  /// Обрезка (`PRUNING`).
  pruning('PRUNING'),

  /// Обработка от вредителей (`PEST_TREATMENT`).
  pestTreatment('PEST_TREATMENT');

  const PlantEventType(this.wireName);

  /// Имя значения на проводе (как отдаёт/принимает backend).
  final String wireName;

  /// Разбор значения с провода; неизвестное → `null` (вызывающий решает, как
  /// деградировать — обычно пропускает запись).
  static PlantEventType? fromWire(String? value) {
    if (value == null) return null;
    for (final type in PlantEventType.values) {
      if (type.wireName == value) return type;
    }
    return null;
  }
}
