import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../env/app_config.dart';
import 'auth_session.dart';
import 'dev_auth_session.dart';

part 'auth_providers.g.dart';

/// Текущая сессия (MADR-008). Сейчас всегда dev-слот; при появлении JWT —
/// ветка на `JwtAuthSession`, остальной код не меняется.
@riverpod
AuthSession authSession(Ref ref) =>
    DevAuthSession(ref.watch(appConfigProvider));
