import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../home/domain/plant.dart';
import '../../home/presentation/home_providers.dart';
import '../../plant_card/data/plant_card_repository_provider.dart';
import '../../plant_card/presentation/plant_card_providers.dart';
import '../data/edit_plant_repository_provider.dart';
import '../domain/edit_plant_draft.dart';
import 'edit_plant_state.dart';

part 'edit_plant_controller.g.dart';

/// Контроллер экрана «Редактировать растение». Family по [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editPlantControllerProvider(plantId)` →
///   `AsyncValue<EditPlantState>`.
/// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
/// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
///   драфт, не ходят в сеть.
/// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
///   провайдеры деталей растения и главного списка, ставит `success`.
///
/// После [submit] с успехом вызывающий экран должен:
/// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
/// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
///    контроллером — перезагрузка данных произойдёт автоматически.
@riverpod
class EditPlantController extends _$EditPlantController {
  @override
  Future<EditPlantState> build(int plantId) async {
    final Result<Plant> result =
        await ref.watch(plantCardRepositoryProvider).getPlant(plantId);
    final plant = switch (result) {
      Success<Plant>(:final value) => value,
      Failure<Plant>(:final error) => throw error,
    };
    final draft = EditPlantDraft(
      name: plant.name,
      notes: plant.notes,
      locationId: plant.locationId,
      speciesId: plant.speciesId,
    );
    return EditPlantState(initial: draft, draft: draft);
  }

  /// Обновляет имя растения в черновике.
  void setName(String name) => _edit((s) => s.copyWith(draft: s.draft.copyWith(name: name)));

  /// Обновляет заметку растения в черновике. Пустая строка → `null`.
  void setNotes(String notes) {
    final v = notes.trim().isEmpty ? null : notes;
    _edit((s) => s.copyWith(draft: s.draft.copyWith(notes: v)));
  }

  /// Обновляет комнату (locationId) в черновике. `null` — убрать из комнаты.
  void setLocation(int? locationId) =>
      _edit((s) => s.copyWith(draft: s.draft.copyWith(locationId: locationId)));

  /// Обновляет вид (speciesId) в черновике. `null` — без вида.
  void setSpecies(int? speciesId) =>
      _edit((s) => s.copyWith(draft: s.draft.copyWith(speciesId: speciesId)));

  /// Отправляет изменения через `PUT /plants/{id}`.
  ///
  /// Возвращает `null` при успехе, [ApiError] при ошибке. UI может опираться
  /// на [EditPlantState.submitStatus] и [EditPlantState.submitError].
  Future<void> submit() async {
    final current = state.value;
    if (current == null || !current.canSave) return;

    _edit((s) => s.copyWith(
          submitStatus: SubmitStatus.submitting,
          submitError: null,
        ));

    final result = await ref
        .read(editPlantRepositoryProvider)
        .updatePlant(plantId, current.draft);

    switch (result) {
      case Success():
        // Инвалидируем деталь растения и домашний список.
        ref.invalidate(plantDetailProvider(plantId));
        ref.invalidate(homePlantsProvider);
        _edit((s) => s.copyWith(submitStatus: SubmitStatus.success));
      case Failure(:final error):
        _edit((s) => s.copyWith(
              submitStatus: SubmitStatus.failure,
              submitError: error,
            ));
    }
  }

  /// Применяет [updater] к текущему значению `state`, если оно загружено.
  void _edit(EditPlantState Function(EditPlantState) updater) {
    final current = state.value;
    if (current != null) {
      state = AsyncData(updater(current));
    }
  }
}
