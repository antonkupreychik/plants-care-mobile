import '../api/generated/models/location_dto.dart';
import 'garden_location.dart';

/// Маппинг [LocationDto] (`/locations`) → domain [GardenLocation] (MADR-002).
///
/// Общее ядро локаций (делят `home` и `rooms`), живёт в `core/locations/`.
extension LocationDtoMapper on LocationDto {
  GardenLocation toDomain() => GardenLocation(
        id: id,
        name: name,
        isDefault: defaultLocation,
        emoji: emoji,
        createdAt: createdAt,
      );
}
