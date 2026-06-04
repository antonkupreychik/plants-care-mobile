import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_plant_draft.freezed.dart';

/// Черновик редактирования растения (domain-слой).
///
/// Чистый Dart — ни одного Flutter/Riverpod импорта. Используется в
/// [EditPlantController] для отслеживания текущего состояния формы.
@freezed
abstract class EditPlantDraft with _$EditPlantDraft {
  const factory EditPlantDraft({
    required String name,
    String? notes,
    int? locationId,

    /// speciesId будет поддержан после plants-care#228;
    /// до этого поле задизейблено.
    int? speciesId,
  }) = _EditPlantDraft;
}
