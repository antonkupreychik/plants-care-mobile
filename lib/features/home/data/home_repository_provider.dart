import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/home_repository.dart';
import 'home_repository_impl.dart';

part 'home_repository_provider.g.dart';

/// DI-точка для [HomeRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `homeRepositoryProvider.overrideWith(...)`.
@riverpod
HomeRepository homeRepository(Ref ref) =>
    HomeRepositoryImpl(ref.watch(plantsCareApiProvider));
