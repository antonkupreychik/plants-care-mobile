import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/language_repository.dart';
import 'language_repository_impl.dart';

part 'language_repository_provider.g.dart';

/// DI-точка для [LanguageRepository] (MADR-004: граф провайдеров = DI).
///
/// Создаёт [LanguageRepositoryImpl] с [FlutterSecureStorage].
/// В тестах подменяется через `languageRepositoryProvider.overrideWith(...)`.
@riverpod
LanguageRepository languageRepository(Ref ref) =>
    const LanguageRepositoryImpl(FlutterSecureStorage());
