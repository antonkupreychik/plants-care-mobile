import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import 'plant_template.dart';

/// Контракт data-слоя фичи «Шаблоны растений».
///
/// Все методы возвращают `Future<Result<T>>` и НЕ бросают наружу (MADR-011).
/// Presentation зависит только от этого интерфейса (MADR-002).
abstract interface class PlantTemplateRepository {
  /// Список шаблонов пользователя (`GET /api/v1/plant-templates`).
  Future<Result<List<PlantTemplate>>> getTemplates();

  /// Создать шаблон (`POST /api/v1/plant-templates`).
  ///
  /// [name] — имя шаблона (1–40 символов). Если передан [fromPlantId] —
  /// копирует активные расписания ухода из существующего растения.
  Future<Result<PlantTemplate>> createTemplate({
    required String name,
    int? fromPlantId,
  });

  /// Удалить шаблон (`DELETE /api/v1/plant-templates/{id}`).
  Future<Result<void>> deleteTemplate(int id);

  /// Создать растение из шаблона (`POST /api/v1/plant-templates/{id}/instantiate`).
  ///
  /// [plantName] — имя нового растения.
  Future<Result<Plant>> instantiateTemplate({
    required int templateId,
    required String plantName,
  });
}
