import '../../../../core/api/generated/models/location_dto.dart';
import '../../domain/garden_location.dart';

/// Маппинг [LocationDto] (`/locations`) → domain [GardenLocation] (MADR-002).
extension LocationDtoMapper on LocationDto {
  GardenLocation toDomain() => GardenLocation(
        id: id,
        name: name,
        isDefault: defaultLocation,
        emoji: emoji,
        createdAt: createdAt,
      );
}
