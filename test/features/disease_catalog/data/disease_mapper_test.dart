import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/api/generated/models/disease_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/page_response_disease_dto.dart';
import 'package:plantcare_mobile/features/disease_catalog/data/mappers/disease_mapper.dart';

void main() {
  group('DiseaseDtoMapper.toDomain', () {
    test('maps_all_fields_including_optional_latinName', () {
      const dto = DiseaseDto(
        id: 1,
        name: 'Паутинный клещ',
        latinName: 'Tetranychus urticae',
        symptoms: 'Пятна на листьях',
        treatment: 'Акарицид',
        prevention: 'Влажность',
      );

      final domain = dto.toDomain();

      expect(domain.id, 1);
      expect(domain.name, 'Паутинный клещ');
      expect(domain.latinName, 'Tetranychus urticae');
      expect(domain.symptoms, 'Пятна на листьях');
      expect(domain.treatment, 'Акарицид');
      expect(domain.prevention, 'Влажность');
    });

    test('maps_null_latinName', () {
      const dto = DiseaseDto(
        id: 2,
        name: 'Тля',
        symptoms: 'Скопления',
        treatment: 'Инсектицид',
        prevention: 'Осмотр',
      );

      final domain = dto.toDomain();

      expect(domain.latinName, isNull);
    });
  });

  group('PageResponseDiseaseDtoMapper.toDomainList', () {
    test('maps_empty_items_to_empty_list', () {
      const page = PageResponseDiseaseDto(
        items: [],
        total: 0,
        offset: 0,
        limit: 20,
      );

      expect(page.toDomainList(), isEmpty);
    });

    test('maps_multiple_items_preserving_order', () {
      const page = PageResponseDiseaseDto(
        items: [
          DiseaseDto(
            id: 1,
            name: 'А',
            symptoms: 's',
            treatment: 't',
            prevention: 'p',
          ),
          DiseaseDto(
            id: 2,
            name: 'Б',
            symptoms: 's',
            treatment: 't',
            prevention: 'p',
          ),
        ],
        total: 2,
        offset: 0,
        limit: 20,
      );

      final list = page.toDomainList();

      expect(list.length, 2);
      expect(list[0].id, 1);
      expect(list[0].name, 'А');
      expect(list[1].id, 2);
      expect(list[1].name, 'Б');
    });
  });
}
