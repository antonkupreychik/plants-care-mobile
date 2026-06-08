import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_template.freezed.dart';

/// Правило ухода, хранящееся в шаблоне (пара тип → интервал в днях).
@freezed
abstract class PlantTemplateCareRule with _$PlantTemplateCareRule {
  const factory PlantTemplateCareRule({
    required PlantTemplateCareType careType,
    required int intervalDays,
  }) = _PlantTemplateCareRule;
}

/// Тип ухода, соответствующий `PlantTemplateCareRuleDtoCareType` из OpenAPI.
enum PlantTemplateCareType {
  watering,
  misting,
  fertilizing,
  soilCheck,
  unknown,
}

/// Шаблон растения — снимок настроек ухода для быстрого создания похожих.
///
/// Чистый Dart (MADR-002): ни одного Flutter / Riverpod-импорта.
@freezed
abstract class PlantTemplate with _$PlantTemplate {
  const factory PlantTemplate({
    required int id,
    required String name,
    required List<PlantTemplateCareRule> careRules,
    required DateTime createdAt,
  }) = _PlantTemplate;
}
