import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/push_priming_repository.dart';
import 'push_priming_repository_impl.dart';

part 'push_priming_repository_provider.g.dart';

/// DI-точка для [PushPrimingRepository] (MADR-004: граф провайдеров = DI).
///
/// Создаёт [PushPrimingRepositoryImpl] с [FlutterSecureStorage].
/// В тестах подменяется через `pushPrimingRepositoryProvider.overrideWith(...)`.
@riverpod
PushPrimingRepository pushPrimingRepository(Ref ref) =>
    const PushPrimingRepositoryImpl(FlutterSecureStorage());
