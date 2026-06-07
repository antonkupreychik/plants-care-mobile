import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/take_cutting_repository.dart';
import 'take_cutting_repository_impl.dart';

part 'take_cutting_repository_provider.g.dart';

/// DI-точка для [TakeCuttingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `takeCuttingRepositoryProvider.overrideWith(...)`.
@riverpod
TakeCuttingRepository takeCuttingRepository(Ref ref) =>
    TakeCuttingRepositoryImpl(ref.watch(plantsCareApiProvider));
