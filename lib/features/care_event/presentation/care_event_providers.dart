import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/care_event_repository_provider.dart';
import '../domain/log_care_event.dart';

part 'care_event_providers.g.dart';

/// DI-точка use case [LogCareEvent] (MADR-004: граф провайдеров = DI).
/// Notifier зовёт use case, а не репозиторий напрямую (MADR-002).
@riverpod
LogCareEvent logCareEvent(Ref ref) =>
    LogCareEvent(ref.watch(careEventRepositoryProvider));
