import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/notifications_repository.dart';
import 'notifications_repository_impl.dart';

part 'notifications_repository_provider.g.dart';

/// DI-точка для [NotificationsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `notificationsRepositoryProvider.overrideWith(...)`.
@riverpod
NotificationsRepository notificationsRepository(Ref ref) =>
    NotificationsRepositoryImpl(ref.watch(plantsCareApiProvider));
