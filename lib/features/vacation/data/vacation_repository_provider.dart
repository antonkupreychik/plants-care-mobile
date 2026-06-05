import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/vacation_repository.dart';
import 'vacation_repository_impl.dart';

part 'vacation_repository_provider.g.dart';

/// DI-точка для [VacationRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `vacationRepositoryProvider.overrideWith(...)`.
@riverpod
VacationRepository vacationRepository(Ref ref) =>
    VacationRepositoryImpl(ref.watch(plantsCareApiProvider));
