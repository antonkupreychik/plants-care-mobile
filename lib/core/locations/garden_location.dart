import 'package:freezed_annotation/freezed_annotation.dart';

part 'garden_location.freezed.dart';

/// Доменная локация сада (источник — `GET /locations`, [LocationDto]).
///
/// Чистый Dart. `createdAt` — UTC (опционально на стороне backend).
///
/// Общее ядро: делят фичи `home` (чипы локаций) и `rooms` (CRUD комнат),
/// поэтому модель живёт в `core/locations/`, а не внутри одной фичи
/// (FLUTTER.md: общее — только через `core/`, как care-task в `core/care/`).
@freezed
abstract class GardenLocation with _$GardenLocation {
  const factory GardenLocation({
    required int id,
    required String name,

    /// Является ли локация дефолтной у пользователя.
    required bool isDefault,

    /// Эмодзи-иконка локации (если задана).
    String? emoji,
    DateTime? createdAt,
  }) = _GardenLocation;
}
