import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import 'edit_plant_draft.dart';

/// Контракт репозитория редактирования растения.
///
/// Чистый Dart — реализация живёт в data-слое.
abstract interface class EditPlantRepository {
  /// Обновить растение через `PUT /plants/{id}`.
  ///
  /// Возвращает [Result] с обновлённым [Plant] на успех или [ApiError] при
  /// сетевой/серверной ошибке. Ошибки не бросаются наружу — всегда Result.
  Future<Result<Plant>> updatePlant(int id, EditPlantDraft draft);
}
