import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
// Кросс-фичевая инвалидация после успешного POST: созданное растение должно
// появиться в саду. Импорт presentation-провайдера home — то же осознанное
// исключение из «фича не импортит presentation другой фичи», что и в
// log_care_event_controller (зависим от объявления провайдера, не от виджетов).
import '../../home/presentation/home_providers.dart';
import '../data/add_plant_repository_provider.dart';
import '../domain/new_plant_draft.dart';
import '../domain/species_summary.dart';
import 'add_plant_wizard_state.dart';

part 'add_plant_wizard_controller.g.dart';

/// Контроллер мастера добавления растения (экран 04) — держит черновик и ведёт
/// сабмит. Не family: один мастер за раз (autoDispose сбрасывает черновик при
/// закрытии). Виджет читает `ref.watch(addPlantWizardControllerProvider)` и
/// зовёт методы; бизнес-логики/валидации в виджете нет (MADR-002).
///
/// Use case для создания нет (репозиторий тонкий, доменная логика — только
/// валидация имени в [NewPlantDraft]), поэтому [submit] зовёт репозиторий через
/// провайдер напрямую — допустимо, когда отдельного use case не существует.
@riverpod
class AddPlantWizardController extends _$AddPlantWizardController {
  @override
  AddPlantWizardState build() => const AddPlantWizardState();

  /// Выбрать вид (шаг 1). Если имя ещё не введено — префиллим именем вида
  /// (UX: пользователь обычно оставляет его). Сбрасывает статус в idle.
  void selectSpecies(SpeciesSummary species) {
    final draft = state.draft;
    final shouldPrefillName = draft.name.trim().isEmpty;
    state = state.copyWith(
      draft: draft.copyWith(
        species: species,
        name: shouldPrefillName ? species.name : draft.name,
      ),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Задать имя растения (шаг 2). Валидность проверяет [AddPlantWizardState.canSubmit].
  void setName(String name) {
    state = state.copyWith(
      draft: state.draft.copyWith(name: name),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Выбрать локацию (шаг 2). null → дефолтная локация на стороне backend.
  void setLocation(int? locationId) {
    state = state.copyWith(
      draft: state.draft.copyWith(locationId: locationId),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Обновить заметки (шаг 4). Пусто → без заметок.
  void setNotes(String? notes) {
    final trimmed = notes?.trim();
    state = state.copyWith(
      draft: state.draft.copyWith(
        notes: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      ),
      status: const AddPlantSubmitStatus.idle(),
    );
  }

  /// Создать растение (`POST /plants`). Single-call gate через [canSubmit]
  /// (валидное имя + не идёт отправка) — повторный тап во время in-flight
  /// игнорируется. Возвращает id созданной записи при успехе, иначе null.
  ///
  /// На успех инвалидирует `homePlantsProvider` (растение появляется в саду) и
  /// кладёт `success(id)` в статус. На ошибку — типизированный [ApiError] в
  /// статус (UI рисует по типу). Отправляем `name + locationId + notes +
  /// speciesId` (последний — id выбранного вида или null). Backend связывает
  /// растение с видом; расписания ухода при этом НЕ создаются (gap G14).
  Future<int?> submit() async {
    if (!state.canSubmit) return null;

    final draft = state.draft;
    state = state.copyWith(status: const AddPlantSubmitStatus.submitting());

    final result = await ref.read(addPlantRepositoryProvider).createPlant(
          name: draft.trimmedName,
          locationId: draft.locationId,
          notes: draft.notes,
          speciesId: draft.species?.id,
        );

    // autoDispose: если мастер закрыли во время in-flight POST — notifier
    // диспоузнут, дальше трогать ref/state нельзя (StateError). Запись уже
    // создаётся; просто выходим.
    if (!ref.mounted) return null;

    switch (result) {
      case Success(:final value):
        ref.invalidate(homePlantsProvider);
        state = state.copyWith(status: AddPlantSubmitStatus.success(value));
        return value;
      case Failure(:final error):
        state = state.copyWith(status: AddPlantSubmitStatus.failure(error));
        return null;
    }
  }
}
