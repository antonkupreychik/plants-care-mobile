import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/shopping_repository.dart';
import 'shopping_repository_impl.dart';

part 'shopping_repository_provider.g.dart';

/// DI-точка для [ShoppingRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `shoppingRepositoryProvider.overrideWith(...)`.
@riverpod
ShoppingRepository shoppingRepository(Ref ref) =>
    ShoppingRepositoryImpl(ref.watch(plantsCareApiProvider));
