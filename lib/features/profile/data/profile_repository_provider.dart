import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/profile_repository.dart';
import 'profile_repository_impl.dart';

part 'profile_repository_provider.g.dart';

/// DI-точка для [ProfileRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `profileRepositoryProvider.overrideWith(...)`.
@riverpod
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepositoryImpl(ref.watch(plantsCareApiProvider));
