import 'package:freezed_annotation/freezed_annotation.dart';

import 'diagnosis_issue.dart';

part 'plant_diagnosis.freezed.dart';

/// Результат пассивной диагностики растения (источник —
/// `GET /plants/{id}/diagnosis`, [PlantDiagnosisDto]).
///
/// Чистый Dart. Диагноз пассивный: выводится из имеющихся данных
/// (просроченные расписания, health-зона) без ИИ и опросника.
///
/// Если у растения данных меньше порога (`< 3` записей ухода), backend
/// возвращает `issues = []` и `recommendations` с единственной подсказкой
/// продолжать отмечать уход — [isHealthy] при этом `false`.
///
/// Здоровое растение (данных достаточно, нет просрочек, зона не `RED`):
/// оба массива пустые, [isHealthy] → `true`.
@freezed
abstract class PlantDiagnosis with _$PlantDiagnosis {
  const PlantDiagnosis._();

  const factory PlantDiagnosis({
    /// Выявленные проблемы, отсортированы по severity (HIGH → LOW).
    required List<DiagnosisIssue> issues,

    /// Рекомендации, собранные по проблемам с дедупликацией.
    required List<String> recommendations,
  }) = _PlantDiagnosis;

  /// Растение полностью здорово: никаких проблем, никаких рекомендаций.
  bool get isHealthy => issues.isEmpty && recommendations.isEmpty;
}
