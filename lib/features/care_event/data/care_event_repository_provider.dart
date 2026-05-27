import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/care_event_repository.dart';
import 'care_event_repository_impl.dart';

part 'care_event_repository_provider.g.dart';

/// DI-точка для [CareEventRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `careEventRepositoryProvider.overrideWith(...)`.
@riverpod
CareEventRepository careEventRepository(Ref ref) =>
    CareEventRepositoryImpl(ref.watch(plantsCareApiProvider));
