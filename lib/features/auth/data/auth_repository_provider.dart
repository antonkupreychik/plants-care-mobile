import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/auth_providers.dart';
import '../domain/auth_repository.dart';
import 'auth_repository_impl.dart';
import 'social_sign_in_impl.dart';

part 'auth_repository_provider.g.dart';

/// DI-точка для [AuthRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `authRepositoryProvider.overrideWith(...)`.
@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      ref.watch(plantsCareApiProvider),
      ref.watch(jwtAuthSessionProvider),
      ref.watch(authStatusProvider),
      ref.watch(socialSignInProvider),
      const FlutterSecureStorage(),
    );
