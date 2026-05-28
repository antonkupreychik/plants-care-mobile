import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/weather_repository.dart';
import 'weather_repository_impl.dart';

part 'weather_repository_provider.g.dart';

/// DI-точка для [WeatherRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `weatherRepositoryProvider.overrideWith(...)`.
@riverpod
WeatherRepository weatherRepository(Ref ref) =>
    WeatherRepositoryImpl(ref.watch(plantsCareApiProvider));
