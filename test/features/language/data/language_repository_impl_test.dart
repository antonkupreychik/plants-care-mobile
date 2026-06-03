import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/features/language/data/language_repository_impl.dart';
import 'package:plantcare_mobile/features/language/domain/app_language.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage storage;
  late LanguageRepositoryImpl repo;

  setUp(() {
    storage = MockFlutterSecureStorage();
    repo = LanguageRepositoryImpl(storage);
  });

  group('getLanguage', () {
    test('should_return_ru_when_stored_value_is_ru', () async {
      when(() => storage.read(key: 'app_language'))
          .thenAnswer((_) async => 'ru');

      final result = await repo.getLanguage();

      expect(result, AppLanguage.ru);
    });

    test('should_return_en_when_stored_value_is_en', () async {
      when(() => storage.read(key: 'app_language'))
          .thenAnswer((_) async => 'en');

      final result = await repo.getLanguage();

      expect(result, AppLanguage.en);
    });

    test('should_return_ru_when_stored_value_is_null', () async {
      // Ключ отсутствует в хранилище (первый запуск) → ru по умолчанию.
      when(() => storage.read(key: 'app_language'))
          .thenAnswer((_) async => null);

      final result = await repo.getLanguage();

      expect(result, AppLanguage.ru);
    });

    test('should_return_ru_when_stored_value_is_unknown', () async {
      // Хранилище содержит устаревший/повреждённый код → graceful fallback.
      when(() => storage.read(key: 'app_language'))
          .thenAnswer((_) async => 'unknown');

      final result = await repo.getLanguage();

      expect(result, AppLanguage.ru);
    });
  });

  group('saveLanguage', () {
    test('should_write_en_code_when_saving_AppLanguage_en', () async {
      when(
        () => storage.write(
          key: 'app_language',
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await repo.saveLanguage(AppLanguage.en);

      verify(
        () => storage.write(key: 'app_language', value: 'en'),
      ).called(1);
    });

    test('should_write_ru_code_when_saving_AppLanguage_ru', () async {
      when(
        () => storage.write(
          key: 'app_language',
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await repo.saveLanguage(AppLanguage.ru);

      verify(
        () => storage.write(key: 'app_language', value: 'ru'),
      ).called(1);
    });

    test('should_use_locale_languageCode_as_storage_key_value', () async {
      // Auth-слот: гарантируем, что значение хранится как languageCode
      // locale (не как enum.name или другой формат). При смене схемы именования
      // этот тест упадёт, сигнализируя о нарушении обратной совместимости хранилища.
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      for (final lang in AppLanguage.values) {
        await repo.saveLanguage(lang);

        verify(
          () => storage.write(
            key: 'app_language',
            value: lang.languageCode,
          ),
        ).called(1);
      }
    });
  });
}
