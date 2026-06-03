import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/features/language/domain/app_language.dart';
import 'package:plantcare_mobile/features/language/presentation/language_providers.dart';

void main() {
  group('AppLanguage.fromCode', () {
    test('should_return_ru_when_code_is_ru', () {
      expect(AppLanguage.fromCode('ru'), AppLanguage.ru);
    });

    test('should_return_en_when_code_is_en', () {
      expect(AppLanguage.fromCode('en'), AppLanguage.en);
    });

    test('should_fallback_to_ru_when_code_is_null', () {
      expect(AppLanguage.fromCode(null), AppLanguage.ru);
    });

    test('should_fallback_to_ru_when_code_is_unknown', () {
      expect(AppLanguage.fromCode('unknown'), AppLanguage.ru);
    });
  });

  group('AppLanguage.languageCode', () {
    test('should_return_ru_for_AppLanguage_ru', () {
      expect(AppLanguage.ru.languageCode, 'ru');
    });

    test('should_return_en_for_AppLanguage_en', () {
      expect(AppLanguage.en.languageCode, 'en');
    });
  });

  group('AppLanguage.nativeName', () {
    test('should_return_Русский_for_ru', () {
      expect(AppLanguage.ru.nativeName, 'Русский');
    });

    test('should_return_English_for_en', () {
      expect(AppLanguage.en.nativeName, 'English');
    });
  });

  group('AppLanguage.englishName', () {
    test('should_return_Russian_for_ru', () {
      expect(AppLanguage.ru.englishName, 'Russian');
    });

    test('should_return_English_for_en', () {
      expect(AppLanguage.en.englishName, 'English');
    });
  });

  // fromLocale перенесён в presentation (AppLanguageFromLocale extension).
  group('AppLanguageFromLocale.fromLocale (presentation extension)', () {
    test('should_return_ru_when_locale_is_ru', () {
      expect(AppLanguageFromLocale.fromLocale(const Locale('ru')), AppLanguage.ru);
    });

    test('should_return_en_when_locale_is_en', () {
      expect(AppLanguageFromLocale.fromLocale(const Locale('en')), AppLanguage.en);
    });

    test('should_fallback_to_ru_when_locale_is_unknown', () {
      expect(AppLanguageFromLocale.fromLocale(const Locale('uk')), AppLanguage.ru);
    });

    test('should_survive_round_trip_for_all_languages', () {
      for (final lang in AppLanguage.values) {
        final locale = Locale(lang.languageCode);
        expect(
          AppLanguageFromLocale.fromLocale(locale),
          lang,
          reason: 'Round-trip failed for $lang',
        );
      }
    });
  });
}
