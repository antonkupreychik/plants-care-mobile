import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_family_member_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_family_response.dart';
import 'package:plantcare_mobile/features/plant_family/data/mappers/plant_family_mapper.dart';

void main() {
  group('PlantFamilyMemberDtoMapper', () {
    test('should_map_id_and_name', () {
      const dto = PlantFamilyMemberDto(id: 7, name: 'Моника');

      final member = dto.toDomain();

      expect(member.id, 7);
      expect(member.name, 'Моника');
    });
  });

  group('PlantFamilyResponseMapper', () {
    test('should_map_parent_and_children', () {
      const response = PlantFamilyResponse(
        parent: PlantFamilyMemberDto(id: 1, name: 'Мама'),
        children: [
          PlantFamilyMemberDto(id: 2, name: 'Росток A'),
          PlantFamilyMemberDto(id: 3, name: 'Росток B'),
        ],
      );

      final family = response.toDomain();

      expect(family.parent?.id, 1);
      expect(family.parent?.name, 'Мама');
      expect(family.children, hasLength(2));
      expect(family.children.map((c) => c.id), [2, 3]);
      expect(family.hasRelations, isTrue);
    });

    test('should_map_null_parent_as_root', () {
      const response = PlantFamilyResponse(
        parent: null,
        children: [PlantFamilyMemberDto(id: 2, name: 'Росток')],
      );

      final family = response.toDomain();

      expect(family.parent, isNull);
      expect(family.children, hasLength(1));
      expect(family.hasRelations, isTrue);
    });

    test('should_report_no_relations_when_lonely_plant', () {
      const response = PlantFamilyResponse(parent: null, children: []);

      final family = response.toDomain();

      expect(family.hasRelations, isFalse);
    });

    test('should_preserve_backend_child_order', () {
      const response = PlantFamilyResponse(
        parent: null,
        children: [
          PlantFamilyMemberDto(id: 9, name: 'Девятый'),
          PlantFamilyMemberDto(id: 1, name: 'Первый'),
          PlantFamilyMemberDto(id: 5, name: 'Пятый'),
        ],
      );

      final family = response.toDomain();

      expect(family.children.map((c) => c.id), [9, 1, 5]);
    });
  });
}
