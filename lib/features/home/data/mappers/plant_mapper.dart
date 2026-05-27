import '../../../../core/api/generated/models/plant_dto.dart';
import '../../domain/plant.dart';

/// Маппинг [PlantDto] (`/plants`) → domain [Plant] (MADR-002).
///
/// `healthScore` / mood не маппятся — их нет в API (BACKEND-GAPS G1/G2).
/// `archived` не переносим: список `/plants` отдаёт только активные.
extension PlantDtoMapper on PlantDto {
  Plant toDomain() => Plant(
        id: id,
        name: name,
        notes: notes,
        photoFileId: photoFileId,
        locationId: locationId,
        locationName: locationName,
        speciesId: speciesId,
        speciesName: speciesName,
        createdAt: createdAt,
      );
}
