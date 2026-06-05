import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/care/care_task_type.dart';
import 'species_summary.dart';
import 'window_side.dart';

part 'new_plant_draft.freezed.dart';

/// Черновик нового растения — состояние данных мастера добавления (экран 04).
///
/// Чистый Dart, иммутабельный (мутируется через freezed `copyWith` в
/// контроллере). Шаг мастера (текущая страница) держит UI/PageController — здесь
/// только введённые пользователем данные.
///
/// Что персистится при создании: [name], [locationId], [notes], id выбранного
/// [species], [acquiredAt] и [isNew].
/// `POST /plants` принимает `{name, notes?, locationId?, speciesId?, acquiredAt?, isNew?}`.
/// При заданном `speciesId` backend связывает растение с видом; расписания ухода
/// при этом НЕ создаются (gap G14). [species] используется для префилла имени,
/// показа плана ухода и стартовых значений степперов интервалов.
///
/// [intervalOverrides] хранит только типы, которые пользователь явно изменил
/// относительно рекомендаций вида. При сабмите по ним делается
/// `PUT /plants/{id}/schedules/{type}`.
@freezed
abstract class NewPlantDraft with _$NewPlantDraft {
  const factory NewPlantDraft({
    /// Выбранный на шаге 1 вид. Его id уходит в `POST /plants` как `speciesId`
    /// (null → растение без вида). Также используется для префилла имени и
    /// превью плана ухода.
    SpeciesSummary? species,

    /// Имя растения (шаг 2). Валидируется [isNameValid].
    @Default('') String name,

    /// Выбранная локация (шаг 2). null → backend положит в дефолтную локацию.
    int? locationId,

    /// Заметки пользователя (шаг 4).
    String? notes,

    /// Сторона окна рядом с растением (шаг 04c). null → не выбрано.
    /// UI-only: backend поля пока нет, в `POST /plants` не уходит (см.
    /// [WindowSide]).
    WindowSide? windowSide,

    /// Пользовательские интервалы, изменённые относительно рекомендаций вида
    /// (шаг 3). Ключ — тип ухода, значение — интервал в днях (>= 1).
    /// Пустая карта → пользователь ничего не менял, лишних PUT не делаем.
    @Default({}) Map<CareTaskType, int> intervalOverrides,

    /// Дата приобретения растения (шаг 5). null → пользователь пропустил шаг,
    /// поле не отправляется в `POST /plants`.
    DateTime? acquiredAt,

    /// Признак нового растения (шаг 6). null → пользователь не ответил,
    /// поле не отправляется. true → backend включает акклиматизацию (21 день).
    bool? isNew,
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
