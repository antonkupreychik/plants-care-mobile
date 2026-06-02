import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/user_settings_repository.dart';
import 'user_settings_repository_impl.dart';

part 'user_settings_repository_provider.g.dart';

/// DI-точка для [UserSettingsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через
/// `userSettingsRepositoryProvider.overrideWith(...)`.
@riverpod
UserSettingsRepository userSettingsRepository(Ref ref) =>
    UserSettingsRepositoryImpl(ref.watch(plantsCareApiProvider));
