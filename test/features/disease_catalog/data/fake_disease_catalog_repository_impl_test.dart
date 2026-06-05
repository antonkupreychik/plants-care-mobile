import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/disease_catalog/data/fake_disease_catalog_repository_impl.dart';
import 'package:plantcare_mobile/features/disease_catalog/domain/disease.dart';

void main() {
  const repo = FakeDiseaseCatalogRepositoryImpl();

  List<Disease> unwrap(Result<List<Disease>> r) => switch (r) {
        Success(:final value) => value,
        Failure() => fail('expected success'),
      };

  group('FakeDiseaseCatalogRepositoryImpl.getAll', () {
    test('should_return_non_empty_list', () async {
      final result = await repo.getAll();
      expect(unwrap(result), isNotEmpty);
    });
  });

  group('FakeDiseaseCatalogRepositoryImpl.search', () {
    test('empty_query_returns_full_list', () async {
      final all = unwrap(await repo.getAll());
      final searched = unwrap(await repo.search(''));
      expect(searched.length, all.length);
    });

    test('matches_by_name_case_insensitive', () async {
      final result = unwrap(await repo.search('ТЛЯ'));
      expect(result, isNotEmpty);
      expect(result.every((d) => d.name.toLowerCase().contains('тля')), isTrue);
    });

    test('matches_by_symptom_substring', () async {
      // «паутинк» встречается в симптомах паутинного клеща, не в его имени.
      final result = unwrap(await repo.search('паутинк'));
      expect(result, isNotEmpty);
      expect(
        result.any((d) => d.symptoms.toLowerCase().contains('паутинк')),
        isTrue,
      );
    });

    test('no_match_returns_empty', () async {
      final result = unwrap(await repo.search('zzzнетдиагноза'));
      expect(result, isEmpty);
    });
  });

  group('FakeDiseaseCatalogRepositoryImpl.getById', () {
    test('returns_disease_for_known_id', () async {
      final result = await repo.getById(1);
      final disease = switch (result) {
        Success(:final value) => value,
        Failure() => fail('expected success'),
      };
      expect(disease.id, 1);
    });

    test('returns_notFound_for_unknown_id', () async {
      final result = await repo.getById(99999);
      expect(result, isA<Failure<Disease>>());
      final error = (result as Failure<Disease>).error;
      expect(error, isA<NotFoundError>());
    });
  });
}
