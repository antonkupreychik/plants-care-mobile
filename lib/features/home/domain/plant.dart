import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';

/// Доменная модель растения (источник — `GET /plants`, [PlantDto]).
///
/// Чистый Dart. Сознательно НЕ содержит:
/// - `healthScore` — поля нет в API (BACKEND-GAPS G1), кольцо здоровья UI не рисует;
/// - mood / voiceLine — генерится не в data (BACKEND-GAPS G2); если понадобится,
///   реплика выводится на уровне presentation/UI по типу задачи и просрочке.
///
/// [speciesName] оставлен намеренно: UI выбирает SVG-иллюстрацию по виду
/// (BACKEND-GAPS G6) — это забота ui-builder, не domain.
@freezed
abstract class Plant with _$Plant {
  const factory Plant({
    required int id,
    required String name,

    /// Произвольные заметки пользователя.
    String? notes,

    /// Telegram `file_id` фотографии (для повторной отправки ботом).
    String? photoFileId,

    /// Локация, в которой стоит растение.
    int? locationId,
    String? locationName,

    /// Вид из справочника — UI выбирает иллюстрацию по нему (G6).
    int? speciesId,
    String? speciesName,

    /// Момент создания записи (UTC).
    DateTime? createdAt,
  }) = _Plant;
}
