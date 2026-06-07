import '../../../../core/api/generated/models/plant_family_member_dto.dart';
import '../../../../core/api/generated/models/plant_family_response.dart';
import '../../domain/plant_family.dart';

/// Маппинг сгенерированных DTO родословной ↔ domain (MADR-007: маппинг руками,
/// сгенерированный код не правим). Покрыт тестом.
extension PlantFamilyMemberDtoMapper on PlantFamilyMemberDto {
  PlantFamilyMember toDomain() => PlantFamilyMember(id: id, name: name);
}

extension PlantFamilyResponseMapper on PlantFamilyResponse {
  PlantFamily toDomain() => PlantFamily(
        parent: parent?.toDomain(),
        children:
            children.map((dto) => dto.toDomain()).toList(growable: false),
      );
}
