import 'package:freezed_annotation/freezed_annotation.dart';

import 'species_summary.dart';

part 'new_plant_draft.freezed.dart';

/// Черновик нового растения — состояние данных мастера добавления (экран 04).
///
/// Чистый Dart, иммутабельный (мутируется через freezed `copyWith` в
/// контроллере). Шаг мастера (текущая страница) держит UI/PageController — здесь
/// только введённые пользователем данные.
///
/// Что персистится при создании: только [name], [locationId], [notes]
/// (`POST /plants` принимает `{name, notes?, locationId?}`). [species]
/// используется лишь для префилла имени и показа read-only «плана ухода» —
/// `speciesId` backend не сохраняет (см. BACKEND-GAPS).
@freezed
abstract class NewPlantDraft with _$NewPlantDraft {
  const factory NewPlantDraft({
    /// Выбранный на шаге 1 вид (для префилла имени и превью плана ухода).
    SpeciesSummary? species,

    /// Имя растения (шаг 2). Валидируется [isNameValid].
    @Default('') String name,

    /// Выбранная локация (шаг 2). null → backend положит в дефолтную локацию.
    int? locationId,

    /// Заметки пользователя (шаг 4).
    String? notes,
  }) = _NewPlantDraft;

  const NewPlantDraft._();

  /// Минимальная длина имени (без учёта пробелов по краям).
  static const int nameMinLength = 1;

  /// Максимальная длина имени (ограничение backend `PlantCreateRequest.name`).
  static const int nameMaxLength = 100;

  /// Имя после trim — то, что уйдёт в `POST /plants`.
  String get trimmedName => name.trim();

  /// Единственное место правды о валидности имени: непустое после trim и
  /// в пределах [nameMinLength]..[nameMaxLength]. Контроллер опирается на это
  /// в `canSubmit`, UI — для подсветки ошибки (текст через l10n).
  bool get isNameValid {
    final length = trimmedName.length;
    return length >= nameMinLength && length <= nameMaxLength;
  }
}
