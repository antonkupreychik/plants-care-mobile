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

    /// Является ли локация текущей активной («основной») локацией
    /// пользователя (`users.active_location_id`). Источник мультидомности
    /// (issue #92 Part 2): отдельной сущности «дом» на backend нет, поэтому
    /// «основной дом» = активная локация. `@Default(false)` сохраняет
    /// обратную совместимость существующих конструкторов/тестов.
    @Default(false) bool isActive,

    /// Эмодзи-иконка локации (если задана).
    String? emoji,
    DateTime? createdAt,
  }) = _GardenLocation;
}
