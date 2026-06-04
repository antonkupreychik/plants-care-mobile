import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/reports_repository.dart';
import 'reports_repository_impl.dart';

part 'reports_repository_provider.g.dart';

/// DI-точка для [ReportsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `reportsRepositoryProvider.overrideWith(...)`.
@riverpod
ReportsRepository reportsRepository(Ref ref) =>
    ReportsRepositoryImpl(ref.watch(plantsCareApiProvider));
