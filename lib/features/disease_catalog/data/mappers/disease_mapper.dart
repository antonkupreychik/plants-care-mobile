import '../../../../core/api/generated/models/disease_dto.dart';
import '../../../../core/api/generated/models/page_response_disease_dto.dart';
import '../../domain/disease.dart';

/// Маппинг болезней: сгенерированные DTO → domain (MADR-002, MADR-007).
///
/// `DiseaseDto` → [Disease]: все поля 1-к-1, `latinName` опционален.
/// `PageResponseDiseaseDto` → [List<Disease>]: берём `items` и маппим каждый.
extension DiseaseDtoMapper on DiseaseDto {
  Disease toDomain() => Disease(
        id: id,
        name: name,
        latinName: latinName,
        symptoms: symptoms,
        treatment: treatment,
        prevention: prevention,
      );
}

extension PageResponseDiseaseDtoMapper on PageResponseDiseaseDto {
  List<Disease> toDomainList() =>
      items.map((dto) => dto.toDomain()).toList(growable: false);
}
