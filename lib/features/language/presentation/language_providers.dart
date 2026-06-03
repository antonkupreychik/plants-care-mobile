import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/language_repository_provider.dart';
import '../domain/app_language.dart';

part 'language_providers.g.dart';

/// Получить [AppLanguage] из [Locale]. Неизвестная → [AppLanguage.ru].
extension AppLanguageFromLocale on AppLanguage {
  static AppLanguage fromLocale(Locale locale) => switch (locale.languageCode) {
        'en' => AppLanguage.en,
        _ => AppLanguage.ru,
      };
}

/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Codegen (Riverpod 3) генерирует переменную **`localeProvider`**.
///
/// Контракт для ui-builder:
/// - `ref.watch(localeProvider)` → `AsyncValue<Locale>`
/// - `ref.read(localeProvider.notifier).setLanguage(AppLanguage.en)`
/// - `AppLanguageFromLocale.fromLocale(locale)` → текущий язык из локали
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale> build() async {
    final lang = await ref.watch(languageRepositoryProvider).getLanguage();
    return Locale(lang.languageCode);
  }

  /// Переключить язык. Игнорирует повторный вызов пока идёт предыдущий.
  Future<void> setLanguage(AppLanguage language) async {
    if (state.isLoading) return;
    state = AsyncData(Locale(language.languageCode));
    await ref.read(languageRepositoryProvider).saveLanguage(language);
  }
}
