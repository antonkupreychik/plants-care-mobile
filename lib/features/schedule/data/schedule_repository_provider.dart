import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/schedule_repository.dart';
import 'schedule_repository_impl.dart';

part 'schedule_repository_provider.g.dart';

/// DI-точка для [ScheduleRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `scheduleRepositoryProvider.overrideWith(...)`.
@riverpod
ScheduleRepository scheduleRepository(Ref ref) =>
    ScheduleRepositoryImpl(ref.watch(plantsCareApiProvider));
