import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/edit_schedule_repository.dart';
import 'edit_schedule_repository_impl.dart';

part 'edit_schedule_repository_provider.g.dart';

/// DI-точка для [EditScheduleRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `editScheduleRepositoryProvider.overrideWith(...)`.
@riverpod
EditScheduleRepository editScheduleRepository(Ref ref) =>
    EditScheduleRepositoryImpl(ref.watch(plantsCareApiProvider));
