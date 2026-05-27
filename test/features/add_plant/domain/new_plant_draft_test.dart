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
}
