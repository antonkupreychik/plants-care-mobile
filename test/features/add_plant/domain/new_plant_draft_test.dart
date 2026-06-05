import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/add_plant/domain/new_plant_draft.dart';

void main() {
  group('NewPlantDraft.trimmedName', () {
    test('should_trim_surrounding_whitespace', () {
      const draft = NewPlantDraft(name: '  Фикус  ');

      expect(draft.trimmedName, 'Фикус');
    });
  });

  group('NewPlantDraft.isNameValid', () {
    test('should_be_false_when_name_empty', () {
      const draft = NewPlantDraft(name: '');

      expect(draft.isNameValid, isFalse);
    });

    test('should_be_false_when_name_only_whitespace', () {
      const draft = NewPlantDraft(name: '    ');

      expect(draft.isNameValid, isFalse);
    });

    test('should_be_true_for_single_char', () {
      const draft = NewPlantDraft(name: 'A');

      expect(draft.isNameValid, isTrue);
    });

    test('should_be_true_for_max_length_after_trim', () {
      final draft = NewPlantDraft(name: '  ${'a' * NewPlantDraft.nameMaxLength}  ');

      // Длина после trim ровно nameMaxLength (100) — на границе валидно.
      expect(draft.trimmedName.length, NewPlantDraft.nameMaxLength);
      expect(draft.isNameValid, isTrue);
    });

    test('should_be_false_when_length_exceeds_max', () {
      final draft = NewPlantDraft(name: 'a' * (NewPlantDraft.nameMaxLength + 1));

      expect(draft.isNameValid, isFalse);
    });
  });

  group('NewPlantDraft.acquiredAt', () {
    test('should_be_null_by_default', () {
      const draft = NewPlantDraft(name: 'Фикус');

      expect(draft.acquiredAt, isNull);
    });

    test('should_store_acquired_date_when_set', () {
      final date = DateTime(2026, 5, 20);
      final draft = NewPlantDraft(name: 'Фикус', acquiredAt: date);

      expect(draft.acquiredAt, date);
    });

    test('should_update_via_copyWith_and_not_mutate_original', () {
      const draft = NewPlantDraft(name: 'Фикус');
      final newDate = DateTime(2026, 1, 15);
      final updated = draft.copyWith(acquiredAt: newDate);

      expect(updated.acquiredAt, newDate);
      expect(draft.acquiredAt, isNull); // оригинал не изменён
    });
  });

  group('NewPlantDraft.isNew', () {
    test('should_be_null_by_default', () {
      const draft = NewPlantDraft(name: 'Фикус');

      expect(draft.isNew, isNull);
    });

    test('should_store_true_when_plant_is_new', () {
      const draft = NewPlantDraft(name: 'Фикус', isNew: true);

      expect(draft.isNew, isTrue);
    });

    test('should_store_false_when_plant_is_adapted', () {
      const draft = NewPlantDraft(name: 'Фикус', isNew: false);

      expect(draft.isNew, isFalse);
    });

    test('should_update_via_copyWith_and_not_mutate_original', () {
      const draft = NewPlantDraft(name: 'Фикус');
      final updated = draft.copyWith(isNew: true);

      expect(updated.isNew, isTrue);
      expect(draft.isNew, isNull); // оригинал не изменён
    });
  });
}
