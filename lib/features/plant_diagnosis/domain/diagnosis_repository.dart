import '../../../core/error/result.dart';
import 'plant_diagnosis.dart';

/// Контракт data-слоя для экрана «Диагноз растения».
///
/// Один метод — один ресурс. Возвращает `Future<Result<T>>` и НЕ бросает
/// наружу (MADR-011). Реализация — [DiagnosisRepositoryImpl] в data-слое.
abstract interface class DiagnosisRepository {
  /// Пассивная диагностика растения (`GET /plants/{id}/diagnosis`, scope user).
  ///
  /// Backend анализирует просроченные расписания и health-зону. Никаких
  /// side-эффектов не производит.
  Future<Result<PlantDiagnosis>> getDiagnosis(int plantId);
}
