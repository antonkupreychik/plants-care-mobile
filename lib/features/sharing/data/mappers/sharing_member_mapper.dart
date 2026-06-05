import '../../../../core/api/generated/models/sharing_member_dto.dart';
import '../../../../core/api/generated/models/sharing_status.dart';
import '../../domain/sharing_member.dart';

/// Маппинг сгенерированного [SharingMemberDto] → domain [SharingMember]
/// (MADR-007: маппинг руками, покрыт тестом).
extension SharingMemberDtoMapper on SharingMemberDto {
  SharingMember toDomain() => SharingMember(
        id: id,
        contact: contact,
        status: status.toDomain(),
        canLogCare: canLogCare,
        // Копируем в неизменяемый список — сгенерированный DTO может отдать
        // тот же инстанс, domain-модель должна владеть своими данными.
        plantIds: List<int>.unmodifiable(plantIds),
      );
}

/// Маппинг enum статуса DTO → domain. `$unknown` (и любое новое значение
/// backend) → [SharingMemberStatus.unknown] — forward-compatibility.
extension SharingStatusMapper on SharingStatus {
  SharingMemberStatus toDomain() => switch (this) {
        SharingStatus.pending => SharingMemberStatus.pending,
        SharingStatus.accepted => SharingMemberStatus.accepted,
        SharingStatus.$unknown => SharingMemberStatus.unknown,
      };
}
