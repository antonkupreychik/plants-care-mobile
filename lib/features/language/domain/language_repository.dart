import 'app_language.dart';

/// Контракт хранилища предпочтения языка.
///
/// Чистый Dart — ни Flutter, ни Riverpod, ни dio.
/// Реализация — [LanguageRepositoryImpl] в data-слое.
abstract class LanguageRepository {
  /// Вернуть сохранённый язык. Если ничего не сохранено — [AppLanguage.ru].
  Future<AppLanguage> getLanguage();

  /// Сохранить выбранный язык.
  Future<void> saveLanguage(AppLanguage language);
}
