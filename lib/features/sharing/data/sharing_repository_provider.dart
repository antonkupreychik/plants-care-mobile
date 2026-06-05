import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/sharing_repository.dart';
import 'sharing_repository_impl.dart';

part 'sharing_repository_provider.g.dart';

/// DI-точка для [SharingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `sharingRepositoryProvider.overrideWith(...)`.
@riverpod
SharingRepository sharingRepository(Ref ref) =>
    SharingRepositoryImpl(ref.watch(plantsCareApiProvider));
