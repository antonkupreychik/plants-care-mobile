import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/seasonal_settings_repository.dart';
import 'seasonal_settings_repository_impl.dart';

part 'seasonal_settings_repository_provider.g.dart';

/// DI-точка для [SeasonalSettingsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через
/// `seasonalSettingsRepositoryProvider.overrideWith(...)`.
@riverpod
SeasonalSettingsRepository seasonalSettingsRepository(Ref ref) =>
    SeasonalSettingsRepositoryImpl(ref.watch(plantsCareApiProvider));
