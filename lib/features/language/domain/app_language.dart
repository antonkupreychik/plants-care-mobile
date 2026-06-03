/// Поддерживаемые языки приложения.
///
/// Чистый Dart-enum без Flutter-зависимостей (MADR-003).
/// Преобразование в [Locale] — в presentation-слое.
enum AppLanguage {
  ru,
  en;

  /// BCP-47 код языка — ключ хранения и аргумент [Locale].
  String get languageCode => switch (this) {
        AppLanguage.ru => 'ru',
        AppLanguage.en => 'en',
      };

  /// Название на родном языке.
  String get nativeName => switch (this) {
        AppLanguage.ru => 'Русский',
        AppLanguage.en => 'English',
      };

  /// Название на английском.
  String get englishName => switch (this) {
        AppLanguage.ru => 'Russian',
        AppLanguage.en => 'English',
      };

  /// Определить язык по строковому коду ('ru' / 'en' / null). Неизвестный → [AppLanguage.ru].
  static AppLanguage fromCode(String? code) => switch (code) {
        'en' => AppLanguage.en,
        _ => AppLanguage.ru,
      };
}
