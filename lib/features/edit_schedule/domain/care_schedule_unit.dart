/// Единица интервала расписания ухода (поле `unit` в `CareScheduleDto`).
///
/// Backend отдаёт строку (сейчас только `DAY`). Нормализацию строки в этот
/// enum делает маппер data-слоя (MADR-002) — по аналогии с
/// `CareTaskType.fromApi`. Неизвестное значение → [unknown] (не падаем, UI
/// рисует нейтрально).
///
/// Чистый Dart, без Flutter/Riverpod.
enum CareScheduleUnit {
  /// Интервал в днях (`DAY`).
  day,

  /// Нераспознанная единица — контракт мог добавить новую.
  unknown;

  /// Маппинг строкового `unit` из backend в domain-enum.
  /// Неизвестное значение → [CareScheduleUnit.unknown] (не бросаем).
  static CareScheduleUnit fromApi(String raw) => switch (raw.toUpperCase()) {
        'DAY' => CareScheduleUnit.day,
        _ => CareScheduleUnit.unknown,
      };

  /// Обратный маппинг в backend-строку для `PUT` (`CareScheduleUpdateRequest`).
  ///
  /// [unknown] не имеет известного представления — отправлять его обратно
  /// нельзя; маппер data-слоя для незнакомой единицы переиспользует исходную
  /// строку DTO (см. маппер), поэтому здесь [unknown] не достигается при
  /// сохранении загруженного с backend расписания.
  String? get apiValue => switch (this) {
        CareScheduleUnit.day => 'DAY',
        CareScheduleUnit.unknown => null,
      };
}
