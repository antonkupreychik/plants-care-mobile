import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/rooms_repository.dart';
import 'rooms_repository_impl.dart';

part 'rooms_repository_provider.g.dart';

/// DI-точка для [RoomsRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `roomsRepositoryProvider.overrideWith(...)`.
@riverpod
RoomsRepository roomsRepository(Ref ref) =>
    RoomsRepositoryImpl(ref.watch(plantsCareApiProvider));
