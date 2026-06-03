import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/app_language.dart';
import '../domain/language_repository.dart';

/// Реализация [LanguageRepository] поверх [FlutterSecureStorage].
///
/// Ключ хранения: [_key] = `'app_language'`.
/// Ошибок хранения здесь нет — fallback к [AppLanguage.ru] при любом сбое.
class LanguageRepositoryImpl implements LanguageRepository {
  const LanguageRepositoryImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const String _key = 'app_language';

  @override
  Future<AppLanguage> getLanguage() async {
    final value = await _storage.read(key: _key);
    return AppLanguage.fromCode(value);
  }

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    // TODO(#34): sync locale preference to PATCH /me {locale} after bearer-migration
    await _storage.write(key: _key, value: language.languageCode);
  }
}
