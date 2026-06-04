/// Серьёзность выявленной проблемы растения (domain-эквивалент
/// [DiagnosisIssueDtoSeverity]).
///
/// Чистый Dart: без Flutter-импортов, без Riverpod. Маппинг из DTO-enum
/// выполняется в маппере data-слоя.
enum DiagnosisSeverity {
  high,
  medium,
  low,

  /// Используется при получении значения, неизвестного клиенту
  /// (forward-совместимость: backend добавил новый уровень).
  unknown,
}
