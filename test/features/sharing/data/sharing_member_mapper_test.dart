import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/sharing_member_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/sharing_status.dart';
import 'package:plantcare_mobile/features/sharing/data/mappers/sharing_member_mapper.dart';
import 'package:plantcare_mobile/features/sharing/domain/sharing_member.dart';

void main() {
  group('SharingMemberDtoMapper.toDomain', () {
    test('should_map_all_fields_and_pending_status', () {
      const dto = SharingMemberDto(
        id: 7,
        contact: '@misha',
        status: SharingStatus.pending,
        canLogCare: true,
        plantIds: [1, 2, 3],
      );

      final member = dto.toDomain();

      expect(member.id, 7);
      expect(member.contact, '@misha');
      expect(member.status, SharingMemberStatus.pending);
      expect(member.canLogCare, isTrue);
      expect(member.plantIds, [1, 2, 3]);
    });

    test('should_map_accepted_status', () {
      const dto = SharingMemberDto(
        id: 1,
        contact: '+79990001122',
        status: SharingStatus.accepted,
        canLogCare: false,
        plantIds: [9],
      );

      expect(dto.toDomain().status, SharingMemberStatus.accepted);
      expect(dto.toDomain().canLogCare, isFalse);
    });

    test('should_map_unknown_status_for_forward_compatibility', () {
      // backend прислал новое значение статуса → DTO декодирует как $unknown,
      // domain не должен падать.
      const dto = SharingMemberDto(
        id: 2,
        contact: '@x',
        status: SharingStatus.$unknown,
        canLogCare: false,
        plantIds: [],
      );

      expect(dto.toDomain().status, SharingMemberStatus.unknown);
    });

    test('should_expose_plantIds_as_unmodifiable_list', () {
      const dto = SharingMemberDto(
        id: 3,
        contact: '@y',
        status: SharingStatus.pending,
        canLogCare: false,
        plantIds: [5],
      );

      final ids = dto.toDomain().plantIds;

      expect(() => ids.add(99), throwsUnsupportedError);
    });
  });
}
