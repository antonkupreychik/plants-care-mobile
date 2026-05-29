import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/care_history_repository.dart';
import 'care_history_repository_impl.dart';

part 'care_history_repository_provider.g.dart';

/// DI-точка для [CareHistoryRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `careHistoryRepositoryProvider.overrideWith(...)`.
@riverpod
CareHistoryRepository careHistoryRepository(Ref ref) =>
    CareHistoryRepositoryImpl(ref.watch(plantsCareApiProvider));
