import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../network/dio_provider.dart';
import '../domain/sdui_repository.dart';
import 'sdui_repository_impl.dart';

part 'sdui_repository_provider.g.dart';

/// DI-точка для [SduiRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `sduiRepositoryProvider.overrideWith(...)`.
@riverpod
SduiRepository sduiRepository(Ref ref) =>
    SduiRepositoryImpl(ref.watch(dioProvider));
