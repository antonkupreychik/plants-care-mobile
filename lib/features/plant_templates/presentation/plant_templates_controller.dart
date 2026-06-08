import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../data/plant_template_repository_provider.dart';
import '../domain/plant_template.dart';

part 'plant_templates_controller.g.dart';

/// State-слой фичи «Шаблоны растений».
///
/// Список шаблонов — `AsyncValue<List<PlantTemplate>>` (loading / error / data).
/// UI читает через `ref.watch(plantTemplatesControllerProvider)`.
///
/// Мутации возвращают `Result<T>` (не `void`): UI матчит
/// `Success`/`Failure(:final error)` и рисует SnackBar по типу `ApiError`
/// через `AppLocalizations` (MADR-011/012).
///
/// После успешной мутации список рефетчится автоматически.
@riverpod
class PlantTemplatesController extends _$PlantTemplatesController {
  @override
  Future<List<PlantTemplate>> build() async {
    final result = await ref.watch(plantTemplateRepositoryProvider).getTemplates();
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }

  /// Создать шаблон из существующего растения или пустой.
  ///
  /// [fromPlantId] — если задан, backend скопирует активные расписания ухода.
  Future<Result<PlantTemplate>> create({
    required String name,
    int? fromPlantId,
  }) async {
    final result = await ref
        .read(plantTemplateRepositoryProvider)
        .createTemplate(name: name, fromPlantId: fromPlantId);
    if (result is Success<PlantTemplate>) await _refresh();
    return result;
  }

  /// Удалить шаблон. Растения, созданные из шаблона, не затрагиваются.
  Future<Result<void>> delete(int id) async {
    final result =
        await ref.read(plantTemplateRepositoryProvider).deleteTemplate(id);
    if (result is Success<void>) await _refresh();
    return result;
  }

  /// Создать растение из шаблона (инстанцирование).
  ///
  /// Возвращает новое [Plant]. При успехе список шаблонов не меняется —
  /// шаблон остаётся (можно создавать ещё); список НЕ рефетчим.
  Future<Result<Plant>> instantiate({
    required int templateId,
    required String plantName,
  }) async {
    return ref.read(plantTemplateRepositoryProvider).instantiateTemplate(
          templateId: templateId,
          plantName: plantName,
        );
  }

  /// Перечитать список шаблонов (loading → data/error).
  Future<void> _refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result =
          await ref.read(plantTemplateRepositoryProvider).getTemplates();
      return switch (result) {
        Success(:final value) => value,
        Failure(:final error) => throw error,
      };
    });
  }
}
